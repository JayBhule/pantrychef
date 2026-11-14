import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../utils/app_theme.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

/// Displays the AI-generated recipe results as attractive cards.
class RecipeResultsScreen extends StatelessWidget {
  final List<Recipe> recipes;
  final MealPreferences preferences;

  const RecipeResultsScreen({
    super.key,
    required this.recipes,
    required this.preferences,
  });

  @override
  Widget build(BuildContext context) {
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
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceWhite,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              size: 20,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recipe Suggestions',
                                style: AppTheme.heading2,
                              ),
                              Text(
                                '${recipes.length} recipes generated for you',
                                style: AppTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Show preferences summary
                    _buildPreferencesSummary(),
                  ],
                ),
              ),
            ),

            // ── Recipe Cards ─────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: RecipeCard(
                        recipe: recipes[index],
                        index: index,
                        onTap: () => _openRecipeDetail(context, recipes[index]),
                      ),
                    );
                  },
                  childCount: recipes.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesSummary() {
    final tags = <String>[];
    if (preferences.mealType.isNotEmpty) tags.add(preferences.mealType);
    if (preferences.dietPreference != 'Any') tags.add(preferences.dietPreference);
    if (preferences.cookingTime != 'Any time') tags.add(preferences.cookingTime);

    return Wrap(
      spacing: 8,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            tag,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.primaryOrange,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _openRecipeDetail(BuildContext context, Recipe recipe) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
    );
  }
}
