import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../utils/app_theme.dart';

/// An attractive recipe card for the results and favourites screens.
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final int index;
  final VoidCallback onTap;
  final bool showRemoveButton;
  final VoidCallback? onRemove;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.index,
    required this.onTap,
    this.showRemoveButton = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Recipe Image ──────────────────────────────────────────────
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: _buildImage(),
              ),
            ),

            // ── Recipe Info ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          recipe.name,
                          style: AppTheme.heading3.copyWith(fontSize: 17),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (showRemoveButton && onRemove != null)
                        GestureDetector(
                          onTap: onRemove,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppTheme.errorRed.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.favorite_rounded,
                              size: 18,
                              color: AppTheme.errorRed,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    recipe.description,
                    style: AppTheme.bodySmall.copyWith(height: 1.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _MetaTag(
                        icon: Icons.timer_rounded,
                        label: recipe.cookingTime,
                        color: AppTheme.primaryOrange,
                      ),
                      const SizedBox(width: 10),
                      _MetaTag(
                        icon: Icons.bar_chart_rounded,
                        label: recipe.difficulty,
                        color: _difficultyColor(recipe.difficulty),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'View Recipe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (recipe.imageUrl.isEmpty) {
      return _buildPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: recipe.imageUrl,
      fit: BoxFit.cover,
      placeholder: (_, __) => _buildPlaceholderAnimated(),
      errorWidget: (_, __, ___) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    // Gradient placeholder with food emoji – visually attractive fallback
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryOrange.withOpacity(0.7),
            AppTheme.accentAmber.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          _getFoodEmoji(index),
          style: const TextStyle(fontSize: 72),
        ),
      ),
    );
  }

  Widget _buildPlaceholderAnimated() {
    return Container(
      color: AppTheme.chipBg,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryOrange,
          strokeWidth: 2,
        ),
      ),
    );
  }

  String _getFoodEmoji(int index) {
    const emojis = ['🍲', '🥘', '🍛', '🥗', '🍜', '🥙', '🍝', '🍳'];
    return emojis[index % emojis.length];
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
}

class _MetaTag extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaTag({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
