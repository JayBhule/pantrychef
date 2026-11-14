import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';
import '../utils/app_constants.dart';

/// Manages local persistence of favourite recipes using SharedPreferences.
///
/// Recipes are serialised to JSON and stored under a single key.
/// This keeps the implementation simple while supporting complex data structures.
class FavouritesStorage {
  FavouritesStorage._();

  static final FavouritesStorage instance = FavouritesStorage._();

  SharedPreferences? _prefs;

  /// Initialises SharedPreferences. Must be called before any read/write.
  Future<void> initialise() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _storage {
    if (_prefs == null) {
      throw StateError(
        'FavouritesStorage not initialised. Call initialise() first.',
      );
    }
    return _prefs!;
  }

  /// Loads all saved favourite recipes from local storage.
  Future<List<Recipe>> loadFavourites() async {
    await initialise();
    final jsonString = _storage.getString(AppConstants.favouritesKey);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // If stored data is corrupted, start fresh
      return [];
    }
  }

  /// Saves a recipe to favourites. If the recipe already exists, it is updated.
  Future<void> saveRecipe(Recipe recipe) async {
    final favourites = await loadFavourites();
    final existing = favourites.indexWhere((r) => r.id == recipe.id);

    final updatedRecipe = recipe.copyWith(isFavourite: true);

    if (existing >= 0) {
      favourites[existing] = updatedRecipe;
    } else {
      favourites.add(updatedRecipe);
    }

    await _persist(favourites);
  }

  /// Removes a recipe from favourites by its ID.
  Future<void> removeRecipe(String recipeId) async {
    final favourites = await loadFavourites();
    favourites.removeWhere((r) => r.id == recipeId);
    await _persist(favourites);
  }

  /// Checks whether a given recipe ID is saved as a favourite.
  Future<bool> isFavourite(String recipeId) async {
    final favourites = await loadFavourites();
    return favourites.any((r) => r.id == recipeId);
  }

  /// Serialises the list of favourites and writes to SharedPreferences.
  Future<void> _persist(List<Recipe> recipes) async {
    final jsonList = recipes.map((r) => r.toJson()).toList();
    await _storage.setString(AppConstants.favouritesKey, jsonEncode(jsonList));
  }
}
