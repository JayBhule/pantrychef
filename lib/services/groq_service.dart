import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';
import '../utils/app_constants.dart';
import '../utils/demo_recipes.dart';

/// Exception thrown when the Groq API returns an error.
class GroqApiException implements Exception {
  final String message;
  final int? statusCode;
  GroqApiException(this.message, {this.statusCode});

  @override
  String toString() => 'GroqApiException: $message (status: $statusCode)';
}

/// Service responsible for all communication with the Groq AI API.
///
/// Security considerations:
///  - API key is loaded from assets/config/api_key.txt (excluded from git).
///  - All requests are made over HTTPS (TLS enforced by Groq's endpoint).
///  - No API key is ever logged or displayed.
///  - Input ingredients are sanitized before being embedded in the prompt.
class GroqService {
  static const String _configAssetPath = 'assets/config/api_key.txt';

  String? _apiKey;
  final http.Client _httpClient;

  GroqService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  /// Loads the API key from:
  /// 1. `--dart-define=GROQ_API_KEY=...` (command line / build environment)
  /// 2. `assets/config/api_key.txt` (local config file, git-ignored)
  Future<void> initialise() async {
    // 1. Check dart-define environment variable first
    const envKey = String.fromEnvironment('GROQ_API_KEY');
    if (envKey.isNotEmpty && !envKey.startsWith('YOUR_')) {
      _apiKey = envKey.trim();
      return;
    }

    // 2. Fall back to local assets/config/api_key.txt file
    try {
      final raw = await rootBundle.loadString(_configAssetPath);
      final key = raw.trim();
      if (key.isNotEmpty &&
          !key.startsWith('YOUR_') &&
          !key.startsWith('#') &&
          key != 'PASTE_YOUR_GROQ_API_KEY_HERE') {
        _apiKey = key;
      }
    } catch (_) {
      // Config file not found – the app will use demo recipes instead.
      _apiKey = null;
    }
  }

  bool get isApiKeyConfigured => _apiKey != null && _apiKey!.isNotEmpty;

  /// Generates 3 recipe suggestions using the Groq AI.
  ///
  /// [preferences] contains the user's ingredients and meal settings.
  ///
  /// Returns demo recipes if the API key is not configured or if the API
  /// call fails, so the UI can always demonstrate its features.
  Future<List<Recipe>> generateRecipes(MealPreferences preferences) async {
    if (!isApiKeyConfigured) {
      // Return demo data so the UI is demonstrable without a key
      return DemoRecipes.getSampleRecipes();
    }

    try {
      final prompt = _buildPrompt(preferences);
      final responseBody = await _callGroqApi(prompt);
      return _parseRecipesFromResponse(responseBody, preferences.ingredients);
    } on GroqApiException {
      rethrow;
    } catch (e) {
      // Fall back to demo recipes on unexpected errors
      throw GroqApiException('Failed to generate recipes. Please try again.');
    }
  }

  /// Builds the structured AI prompt for recipe generation.
  /// The prompt is designed to always return valid JSON for reliable parsing.
  String _buildPrompt(MealPreferences preferences) {
    // Sanitize ingredient names – remove any control characters
    final safeIngredients = preferences.ingredients
        .map((i) => i.trim().replaceAll(RegExp(r'[^\w\s,.-]'), ''))
        .where((i) => i.isNotEmpty)
        .join(', ');

    final dietNote = preferences.dietPreference == 'Any'
        ? 'no dietary restriction'
        : preferences.dietPreference.toLowerCase();

    final timeNote = preferences.cookingTime == 'Any time'
        ? 'any cooking duration'
        : 'a cooking time of ${preferences.cookingTime.toLowerCase()}';

    return '''You are an expert chef assistant. Generate exactly 3 practical and delicious recipe suggestions.

USER'S AVAILABLE INGREDIENTS: $safeIngredients
MEAL TYPE: ${preferences.mealType}
DIETARY PREFERENCE: $dietNote
COOKING TIME: $timeNote

STRICT REQUIREMENTS:
1. Use primarily the ingredients listed above.
2. If a recipe needs 1–3 extra common pantry items, list them in "missing_ingredients".
3. Keep each recipe practical and easy to follow.
4. Respect the dietary preference strictly.
5. Try to respect the cooking time constraint.
6. Do NOT make any health or medical claims.
7. Return ONLY valid JSON — no markdown, no extra text, nothing outside the JSON.

Return this exact JSON structure:
{
  "recipes": [
    {
      "id": "unique_string_id",
      "name": "Recipe Name",
      "description": "One or two sentence description of the dish.",
      "cooking_time": "X minutes",
      "difficulty": "Easy|Medium|Hard",
      "available_ingredients": ["ingredient1", "ingredient2"],
      "missing_ingredients": ["extra1"],
      "steps": [
        "Step 1 description.",
        "Step 2 description.",
        "Step 3 description."
      ]
    }
  ]
}''';
  }

  /// Sends the prompt to the Groq API and returns the raw response body.
  Future<String> _callGroqApi(String prompt) async {
    final requestBody = jsonEncode({
      'model': AppConstants.groqModel,
      'messages': [
        {
          'role': 'system',
          'content':
              'You are a professional chef. Always respond with valid JSON only.',
        },
        {'role': 'user', 'content': prompt},
      ],
      'max_tokens': AppConstants.maxTokens,
      'temperature': 0.7,
      'response_format': {'type': 'json_object'},
    });

    final response = await _httpClient
        .post(
          Uri.parse(AppConstants.groqBaseUrl),
          headers: {
            // API key is passed in the Authorization header – never in the URL
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          body: requestBody,
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 401) {
      throw GroqApiException(
        'Invalid API key. Please check your api_key.txt file.',
        statusCode: 401,
      );
    } else if (response.statusCode == 429) {
      throw GroqApiException(
        'Rate limit exceeded. Please wait a moment and try again.',
        statusCode: 429,
      );
    } else {
      throw GroqApiException(
        'API error (${response.statusCode}). Please try again.',
        statusCode: response.statusCode,
      );
    }
  }

  /// Parses the Groq API response body into a list of Recipe objects.
  /// Handles malformed or unexpected JSON gracefully.
  List<Recipe> _parseRecipesFromResponse(
    String responseBody,
    List<String> userIngredients,
  ) {
    try {
      final outerJson = jsonDecode(responseBody) as Map<String, dynamic>;

      // The Groq response wraps the actual content inside choices[0].message.content
      final content =
          outerJson['choices']?[0]?['message']?['content'] as String?;
      if (content == null || content.isEmpty) {
        throw const FormatException('Empty response content from AI.');
      }

      final recipeJson = jsonDecode(content) as Map<String, dynamic>;
      final recipeList = recipeJson['recipes'] as List<dynamic>?;

      if (recipeList == null || recipeList.isEmpty) {
        throw const FormatException('No recipes found in AI response.');
      }

      // Parse each recipe and assign a food image from our curated list
      return recipeList.asMap().entries.map((entry) {
        final json = Map<String, dynamic>.from(entry.value as Map);
        json['id'] = json['id']?.toString() ??
            'recipe_${DateTime.now().millisecondsSinceEpoch}_${entry.key}';
        json['image_url'] = AppConstants.getRandomFoodImage(entry.key);
        return Recipe.fromJson(json);
      }).toList();
    } on FormatException catch (e) {
      throw GroqApiException('Could not parse AI response: ${e.message}');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
