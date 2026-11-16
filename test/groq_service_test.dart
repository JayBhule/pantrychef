import 'package:flutter_test/flutter_test.dart';
import 'package:pantrychef/models/recipe.dart';
import 'package:pantrychef/utils/app_constants.dart';

void main() {
  group('Recipe model tests', () {
    test('Recipe.fromJson handles string and numeric fields safely', () {
      final json = {
        'id': 12345,
        'name': 'Test Chicken Curry',
        'description': 'Delicious curry',
        'cooking_time': 25,
        'difficulty': 'Easy',
        'available_ingredients': ['Chicken', 'Curd'],
        'missing_ingredients': ['Spices'],
        'steps': ['Marinate chicken with curd', 'Cook for 20 mins'],
        'image_url': 'https://example.com/food.jpg',
      };

      final recipe = Recipe.fromJson(json);

      expect(recipe.id, '12345');
      expect(recipe.name, 'Test Chicken Curry');
      expect(recipe.cookingTime, '25');
      expect(recipe.difficulty, 'Easy');
      expect(recipe.availableIngredients, ['Chicken', 'Curd']);
      expect(recipe.missingIngredients, ['Spices']);
      expect(recipe.steps.length, 2);
    });
  });

  group('AppConstants configuration', () {
    test('Groq model is configured to an active supported model', () {
      expect(AppConstants.groqModel, 'openai/gpt-oss-20b');
      expect(AppConstants.fallbackModels, contains('openai/gpt-oss-120b'));
      expect(AppConstants.fallbackModels, contains('qwen/qwen3.8-27b'));
      expect(AppConstants.groqBaseUrl, 'https://api.groq.com/openai/v1/chat/completions');
    });
  });
}
