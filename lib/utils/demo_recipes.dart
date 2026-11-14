import '../models/recipe.dart';
import 'app_constants.dart';

/// Demo/fallback recipes used when:
///  1. The app is opened without an API key configured.
///  2. The Groq API is temporarily unavailable.
///  3. During UI development and testing.
class DemoRecipes {
  DemoRecipes._();

  static List<Recipe> getSampleRecipes() {
    return [
      Recipe(
        id: 'demo_001',
        name: 'Classic Chicken Stir-Fry',
        description:
            'A quick and flavourful stir-fry using chicken, vegetables and savoury sauce – ready in under 20 minutes.',
        cookingTime: '20 minutes',
        difficulty: 'Easy',
        availableIngredients: [
          'Chicken breast',
          'Onion',
          'Bell pepper',
          'Garlic',
          'Soy sauce',
          'Oil',
        ],
        missingIngredients: ['Sesame oil', 'Ginger'],
        steps: [
          'Slice chicken breast into thin strips and season with salt and pepper.',
          'Heat oil in a wok or large frying pan over high heat.',
          'Add garlic and cook for 30 seconds until fragrant.',
          'Add chicken strips and stir-fry for 4–5 minutes until cooked through.',
          'Add onion and bell pepper, stir-fry for another 3 minutes.',
          'Pour soy sauce over the mixture and toss everything together.',
          'Cook for 1 more minute, then serve hot with rice or noodles.',
        ],
        imageUrl: AppConstants.foodImageUrls[0],
        isFavourite: false,
      ),
      Recipe(
        id: 'demo_002',
        name: 'Tomato & Rice Pilaf',
        description:
            'A simple, comforting one-pot rice dish with tomatoes, onion and herbs.',
        cookingTime: '30 minutes',
        difficulty: 'Easy',
        availableIngredients: [
          'Rice',
          'Tomato',
          'Onion',
          'Garlic',
          'Olive oil',
          'Salt',
        ],
        missingIngredients: ['Vegetable stock', 'Fresh parsley'],
        steps: [
          'Dice the onion and garlic. Chop tomatoes into quarters.',
          'Heat olive oil in a saucepan over medium heat.',
          'Sauté onion until translucent, about 3–4 minutes.',
          'Add garlic and cook for 30 seconds.',
          'Add tomatoes and cook until they soften, about 5 minutes.',
          'Stir in rice and 2 cups of water (or stock). Season with salt.',
          'Bring to a boil, then reduce heat. Cover and simmer for 18 minutes.',
          'Fluff the rice with a fork and serve garnished with parsley.',
        ],
        imageUrl: AppConstants.foodImageUrls[1],
        isFavourite: false,
      ),
      Recipe(
        id: 'demo_003',
        name: 'Spiced Omelette',
        description:
            'A hearty breakfast omelette filled with onion, tomato and spices.',
        cookingTime: '10 minutes',
        difficulty: 'Easy',
        availableIngredients: [
          'Eggs',
          'Onion',
          'Tomato',
          'Green chilli',
          'Oil',
          'Salt',
        ],
        missingIngredients: ['Fresh coriander', 'Cheese'],
        steps: [
          'Crack 3 eggs into a bowl and whisk until combined.',
          'Finely dice onion, tomato and green chilli.',
          'Heat oil in a non-stick pan over medium heat.',
          'Add onion and chilli, sauté for 1–2 minutes.',
          'Add tomato and cook for 1 minute.',
          'Pour in the whisked eggs. Season with salt.',
          'Let the omelette cook until the edges set, then fold in half.',
          'Serve hot with toast or as a breakfast side.',
        ],
        imageUrl: AppConstants.foodImageUrls[2],
        isFavourite: false,
      ),
    ];
  }
}
