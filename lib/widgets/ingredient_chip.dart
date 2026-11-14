import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// A removable chip widget representing a single ingredient.
class IngredientChipWidget extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const IngredientChipWidget({
    super.key,
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.chipBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primaryOrange.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
              child: Text(
                label,
                style: AppTheme.labelMedium.copyWith(
                  color: AppTheme.primaryDeep,
                ),
              ),
            ),
            GestureDetector(
              onTap: onRemove,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: AppTheme.primaryOrange.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
