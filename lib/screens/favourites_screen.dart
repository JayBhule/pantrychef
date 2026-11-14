import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../storage/favourites_storage.dart';
import '../utils/app_theme.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

/// Screen displaying all locally saved favourite recipes.
class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen>
    with AutomaticKeepAliveClientMixin {
  List<Recipe> _favourites = [];
  bool _isLoading = true;

  // Keep state alive when switching tabs
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  /// Loads favourite recipes from local storage.
  Future<void> _loadFavourites() async {
    setState(() => _isLoading = true);
    final favourites = await FavouritesStorage.instance.loadFavourites();
    if (mounted) {
      setState(() {
        _favourites = favourites;
        _isLoading = false;
      });
    }
  }

  /// Removes a recipe from favourites and updates the displayed list.
  Future<void> _removeFromFavourites(String recipeId) async {
    await FavouritesStorage.instance.removeRecipe(recipeId);
    await _loadFavourites();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Recipe removed from favourites'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Favourite Recipes',
                      style: AppTheme.heading2.copyWith(
                        color: AppTheme.primaryOrange,
                      ),
                    ),
                    Text(
                      'Your saved culinary inspiration',
                      style: AppTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            // ── Content ──────────────────────────────────────────────────────
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryOrange,
                  ),
                ),
              )
            else if (_favourites.isEmpty)
              SliverFillRemaining(
                child: _buildEmptyState(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final recipe = _favourites[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Dismissible(
                          key: Key(recipe.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) =>
                              _removeFromFavourites(recipe.id),
                          background: _buildDismissBackground(),
                          child: RecipeCard(
                            recipe: recipe,
                            index: index,
                            onTap: () => _openRecipeDetail(recipe),
                            showRemoveButton: true,
                            onRemove: () => _removeFromFavourites(recipe.id),
                          ),
                        ),
                      );
                    },
                    childCount: _favourites.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.chipBg,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🍽️', style: TextStyle(fontSize: 60)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No favourite recipes yet',
              style: AppTheme.heading3.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 10),
            Text(
              'Generate recipes on the Home tab and save the ones you love by tapping the heart button.',
              textAlign: TextAlign.center,
              style: AppTheme.bodyMedium.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: AppTheme.errorRed,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_rounded, color: Colors.white, size: 28),
          SizedBox(height: 4),
          Text(
            'Remove',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _openRecipeDetail(Recipe recipe) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecipeDetailScreen(recipe: recipe),
      ),
    );
    // Refresh the list in case the user toggled the favourite in the detail screen
    _loadFavourites();
  }
}
