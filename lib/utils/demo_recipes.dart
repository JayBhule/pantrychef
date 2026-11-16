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
          'Prep & Slicing: Slice the chicken breast into thin, uniform strips against the grain to ensure tender bites. Season lightly with salt and freshly cracked black pepper. Thinly slice the onion and slice the bell pepper into long, vibrant strips.',
          'Aromatics Preparation: Finely mince the garlic and grate a small piece of ginger. Keep all prepared vegetables and aromatics organized on a cutting board so you can add them swiftly to the hot pan.',
          'Searing the Chicken: Heat 1 tablespoon of cooking oil in a large wok or skillet over high heat until smoking lightly. Add the seasoned chicken strips in a single layer. Stir-fry briskly for 4 to 5 minutes until fully cooked, nicely browned on edges, and no longer pink. Transfer the chicken to a plate.',
          'Stir-Frying the Vegetables: Add the remaining drizzle of oil to the hot pan. Toss in the minced garlic and sauté for 30 seconds until fragrant. Immediately add the sliced onion and bell pepper, stir-frying vigorously over high heat for 3 minutes until tender-crisp with charred edges.',
          'Saucing & Glazing: Return the cooked chicken strips along with any collected resting juices back into the wok. Drizzle 2 tablespoons of soy sauce and sesame oil over the hot mixture. Toss continuously for 1 to 2 minutes so the savory sauce caramelizes and glazes every ingredient evenly.',
          'Finishing & Serving: Remove from heat immediately to prevent the vegetables from softening. Plate the steaming stir-fry over fluffy white rice or noodles, and garnish with sliced scallions or sesame seeds.',
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
          'Rinsing & Chopping: Thoroughly rinse the rice in cold water until the water runs clear to remove excess starch. Finely dice the onions and mince the garlic cloves. Chop ripe tomatoes into small cubes, capturing all their juices in a bowl.',
          'Sautéing the Aromatics: Heat 2 tablespoons of olive oil in a heavy-bottomed saucepan or Dutch oven over medium heat. Add the diced onion and cook patiently for 4 to 5 minutes until soft, translucent, and sweetly caramelized. Add minced garlic and sauté for another 45 seconds until aromatic.',
          'Simmering the Tomato Base: Tip the chopped tomatoes and their juices into the pan. Stir in 1 teaspoon of salt and pepper. Cook uncovered over medium-low flame for 6 to 7 minutes, stirring occasionally, until the tomatoes break down into a rich, pulpy sauce.',
          'Toasting the Rice: Add the drained rice into the tomato base. Stir continuously for 2 minutes over medium heat, allowing each grain of rice to get coated in the savory tomato reduction and lightly toasted.',
          'Covering & Steaming: Pour in 2 cups of vegetable stock or hot water. Bring the mixture to a rolling boil, then reduce heat to the lowest setting. Cover tightly with a secure lid and simmer undisturbed for 18 minutes without lifting the lid.',
          'Fluffing & Serving: Turn off the heat and let the pot sit covered off the flame for 5 minutes to allow remaining steam to settle. Gently fluff the grains with a fork, sprinkle chopped fresh parsley over top, and serve warm as a satisfying main or side.',
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
          'Prep & Whisking: Crack 3 eggs into a mixing bowl. Add a pinch of salt and black pepper, then whisk vigorously with a fork for 1 full minute until airy and slightly frothy for maximum fluffiness.',
          'Chopping Veggies: Finely dice the onion, deseed and chop the tomato, and thinly slice the green chilli. Fold the chopped vegetables and freshly chopped coriander directly into the whisked egg mixture.',
          'Heating the Skillet: Place an 8-inch non-stick skillet over medium heat and add 1 teaspoon of oil or butter. Swirl the pan so the bottom and lower sides are evenly coated with a shimmering layer of oil.',
          'Pouring & Setting: Pour the egg mixture into the center of the pan. As the eggs begin to cook around the edges after 30 seconds, use a spatula to gently pull cooked edges inward, allowing uncooked liquid egg to flow underneath.',
          'Folding the Omelette: When the top is softly set and glistening (about 2 minutes), sprinkle grated cheese if desired over one half. Slide your spatula underneath and fold the omelette gently in half into a golden crescent.',
          'Finishing & Plating: Cook for an additional 30 seconds until the cheese melts and the underside is lightly golden brown. Slide onto a warm plate and enjoy immediately with toasted bread or hot chai.',
        ],
        imageUrl: AppConstants.foodImageUrls[2],
        isFavourite: false,
      ),
    ];
  }
}
