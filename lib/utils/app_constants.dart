/// Application-wide constants for PantryChef.
class AppConstants {
  AppConstants._();

  // ─── Groq API Configuration ─────────────────────────────────────────────
  /// The Groq API endpoint for chat completions.
  /// API key is loaded at runtime from a local config file (not committed to git).
  static const String groqBaseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  /// The primary Groq model used for recipe generation.
  /// openai/gpt-oss-20b provides fast, reliable structured JSON recipe generation.
  static const String groqModel = 'openai/gpt-oss-20b';

  /// Fallback models tried in sequence if the primary model is unavailable.
  static const List<String> fallbackModels = [
    'openai/gpt-oss-120b',
    'qwen/qwen3.8-27b',
  ];

  /// Maximum tokens for the AI response – generous limit for 3 detailed recipes with step-by-step instructions.
  static const int maxTokens = 4096;

  // ─── SharedPreferences Keys ─────────────────────────────────────────────
  static const String favouritesKey = 'pantrychef_favourites';
  static const String apiKeyStorageKey = 'pantrychef_groq_api_key';

  // ─── Meal Types ─────────────────────────────────────────────────────────
  static const List<String> mealTypes = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];

  // ─── Diet Preferences ───────────────────────────────────────────────────
  static const List<String> dietPreferences = [
    'Any',
    'Vegetarian',
    'Non-Vegetarian',
  ];

  // ─── Cooking Time Options ───────────────────────────────────────────────
  static const List<String> cookingTimeOptions = [
    'Any time',
    'Under 15 minutes',
    'Under 30 minutes',
    'Under 45 minutes',
  ];

  // ─── Difficulty Levels ───────────────────────────────────────────────────
  static const List<String> difficultyLevels = ['Easy', 'Medium', 'Hard'];

  // ─── Recipe Image URLs ───────────────────────────────────────────────────
  /// High-quality food images from Unsplash (free to use, no key required).
  /// Used as fallbacks when the AI doesn't return a specific image URL.
  static const List<String> foodImageUrls = [
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80',
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&q=80',
    'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800&q=80',
    'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800&q=80',
    'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?w=800&q=80',
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80',
    'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800&q=80',
  ];

  static String getRandomFoodImage(int index) {
    return foodImageUrls[index % foodImageUrls.length];
  }
}
