import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../storage/favourites_storage.dart';
import '../utils/app_theme.dart';

/// Full recipe detail screen showing ingredients, steps and favourite button.
class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late bool _isFavourite;
  bool _isTogglingFavourite = false;

  @override
  void initState() {
    super.initState();
    _isFavourite = widget.recipe.isFavourite;
    _checkFavouriteStatus();
  }

  /// Checks the actual stored favourite status when the screen opens.
  Future<void> _checkFavouriteStatus() async {
    final stored =
        await FavouritesStorage.instance.isFavourite(widget.recipe.id);
    if (mounted) setState(() => _isFavourite = stored);
  }

  /// Toggles the recipe's favourite status and persists the change.
  Future<void> _toggleFavourite() async {
    if (_isTogglingFavourite) return;

    setState(() {
      _isTogglingFavourite = true;
      _isFavourite = !_isFavourite;
    });

    try {
      if (_isFavourite) {
        await FavouritesStorage.instance.saveRecipe(widget.recipe);
        if (mounted) _showSnackBar('Added to favourites ❤️');
      } else {
        await FavouritesStorage.instance.removeRecipe(widget.recipe.id);
        if (mounted) _showSnackBar('Removed from favourites');
      }
    } catch (_) {
      // Revert UI on error
      if (mounted) setState(() => _isFavourite = !_isFavourite);
    } finally {
      if (mounted) setState(() => _isTogglingFavourite = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero Image + App Bar ───────────────────────────────────────
              _buildSliverAppBar(context),

              // ── Recipe Header Info ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: _buildRecipeHeader(),
                ),
              ),

              // ── Ingredients You Have ───────────────────────────────────────
              if (widget.recipe.availableIngredients.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: _buildIngredientSection(
                      title: 'Ingredients You Have',
                      icon: Icons.check_circle_rounded,
                      iconColor: AppTheme.successGreen,
                      ingredients: widget.recipe.availableIngredients,
                      bgColor: const Color(0xFFE8F5E9),
                    ),
                  ),
                ),

              // ── Missing Ingredients ────────────────────────────────────────
              if (widget.recipe.missingIngredients.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: _buildIngredientSection(
                      title: 'You May Need',
                      icon: Icons.shopping_cart_outlined,
                      iconColor: AppTheme.accentAmber,
                      ingredients: widget.recipe.missingIngredients,
                      bgColor: const Color(0xFFFFF8E1),
                    ),
                  ),
                ),

              // ── Cooking Instructions ───────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: _buildStepsSection(),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),

          // ── Floating Favourite Button ──────────────────────────────────────
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: _buildFavouriteButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppTheme.backgroundCream,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeroImage(),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  Widget _buildHeroImage() {
    final imageUrl = widget.recipe.imageUrl;

    if (imageUrl.isEmpty) {
      return Container(
        color: AppTheme.chipBg,
        child: const Center(child: Text('🍽️', style: TextStyle(fontSize: 80))),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        color: AppTheme.chipBg,
        child: const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryOrange),
        ),
      ),
      errorWidget: (_, __, ___) => Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: const Center(child: Text('🍽️', style: TextStyle(fontSize: 80))),
      ),
    );
  }

  Widget _buildRecipeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.recipe.name, style: AppTheme.heading2),
        const SizedBox(height: 8),
        Text(
          widget.recipe.description,
          style: AppTheme.bodyMedium.copyWith(height: 1.5),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _InfoBadge(
              icon: Icons.timer_rounded,
              label: widget.recipe.cookingTime,
              color: AppTheme.primaryOrange,
            ),
            const SizedBox(width: 12),
            _InfoBadge(
              icon: Icons.bar_chart_rounded,
              label: widget.recipe.difficulty,
              color: _difficultyColor(widget.recipe.difficulty),
            ),
          ],
        ),
      ],
    );
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppTheme.successGreen;
      case 'hard':
        return AppTheme.errorRed;
      default:
        return AppTheme.accentAmber;
    }
  }

  Widget _buildIngredientSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> ingredients,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 8),
              Text(title, style: AppTheme.heading3.copyWith(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ingredients
                .map(
                  (ing) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(ing, style: AppTheme.labelMedium),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.format_list_numbered_rounded,
              size: 20,
              color: AppTheme.primaryOrange,
            ),
            const SizedBox(width: 8),
            Text('Cooking Instructions', style: AppTheme.heading3),
          ],
        ),
        const SizedBox(height: 16),
        ...widget.recipe.steps.asMap().entries.map((entry) {
          return _StepCard(stepNumber: entry.key + 1, step: entry.value);
        }),
      ],
    );
  }

  Widget _buildFavouriteButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: _isTogglingFavourite ? null : _toggleFavourite,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _isFavourite ? AppTheme.errorRed : AppTheme.primaryOrange,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: (_isFavourite ? AppTheme.errorRed : AppTheme.primaryOrange)
              .withOpacity(0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isFavourite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              _isFavourite ? 'Remove from Favourites' : 'Save to Favourites',
              style: AppTheme.buttonText,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int stepNumber;
  final String step;

  const _StepCard({required this.stepNumber, required this.step});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(top: 2),
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                step,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textPrimary,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
