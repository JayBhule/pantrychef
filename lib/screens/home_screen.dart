import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/groq_service.dart';
import '../utils/app_constants.dart';
import '../utils/app_theme.dart';
import '../widgets/ingredient_chip.dart';
import '../widgets/preference_selector.dart';
import 'recipe_results_screen.dart';

/// Main home screen where users enter ingredients and preferences.
class HomeScreen extends StatefulWidget {
  final GroqService groqService;

  const HomeScreen({super.key, required this.groqService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _ingredientController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<String> _ingredients = [];
  String _selectedMealType = 'Any';
  String _selectedDiet = 'Any';
  String _selectedCookingTime = 'Any time';
  bool _isLoading = false;

  // Keep state alive when switching tabs
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _ingredientController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Adds the typed ingredient to the chip list.
  void _addIngredient() {
    final text = _ingredientController.text.trim();
    if (text.isEmpty) return;

    // Split on comma so users can type "Chicken, Rice, Tomato" at once
    final parts = text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty);

    setState(() {
      for (final part in parts) {
        final capitalised = part[0].toUpperCase() + part.substring(1).toLowerCase();
        if (!_ingredients.contains(capitalised) && _ingredients.length < 20) {
          _ingredients.add(capitalised);
        }
      }
    });

    _ingredientController.clear();
    _focusNode.requestFocus();
  }

  void _removeIngredient(String ingredient) {
    setState(() => _ingredients.remove(ingredient));
  }

  /// Validates inputs and triggers AI recipe generation.
  Future<void> _generateRecipes() async {
    if (_ingredients.isEmpty) {
      _showSnackBar(
        'Please add at least one ingredient to get started.',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final preferences = MealPreferences(
        ingredients: List<String>.from(_ingredients),
        mealType: _selectedMealType == 'Any' ? 'Any meal' : _selectedMealType,
        dietPreference: _selectedDiet,
        cookingTime: _selectedCookingTime,
      );

      final recipes = await widget.groqService.generateRecipes(preferences);

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RecipeResultsScreen(
            recipes: recipes,
            preferences: preferences,
          ),
        ),
      );
    } on GroqApiException catch (e) {
      if (mounted) _showSnackBar(e.message, isError: true);
    } catch (_) {
      if (mounted) {
        _showSnackBar(
          'Something went wrong. Please check your connection.',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.errorRed : AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App Bar ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PantryChef 🍳',
                          style: AppTheme.heading2.copyWith(
                            color: AppTheme.primaryOrange,
                          ),
                        ),
                        Text(
                          'What\'s in your pantry today?',
                          style: AppTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Hero Banner ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: _buildHeroBanner(),
              ),
            ),

            // ── Ingredient Input ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: _buildIngredientSection(),
              ),
            ),

            // ── Ingredient Chips ───────────────────────────────────────────
            if (_ingredients.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                  child: _buildIngredientChips(),
                ),
              ),

            // ── Meal Type ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: PreferenceSelector(
                  title: 'Meal Type',
                  icon: Icons.restaurant_menu_rounded,
                  options: ['Any', ...AppConstants.mealTypes],
                  selected: _selectedMealType,
                  onSelected: (v) => setState(() => _selectedMealType = v),
                ),
              ),
            ),

            // ── Diet Preference ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: PreferenceSelector(
                  title: 'Food Preference',
                  icon: Icons.eco_rounded,
                  options: AppConstants.dietPreferences,
                  selected: _selectedDiet,
                  onSelected: (v) => setState(() => _selectedDiet = v),
                ),
              ),
            ),

            // ── Cooking Time ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: PreferenceSelector(
                  title: 'Cooking Time',
                  icon: Icons.timer_rounded,
                  options: AppConstants.cookingTimeOptions,
                  selected: _selectedCookingTime,
                  onSelected: (v) => setState(() => _selectedCookingTime = v),
                ),
              ),
            ),

            // ── API Key Notice (if not configured) ─────────────────────────
            if (!widget.groqService.isApiKeyConfigured)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: _buildApiKeyNotice(),
                ),
              ),

            // ── Generate Button ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: _buildGenerateButton(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'AI-Powered\nRecipe Magic ✨',
                    style: AppTheme.heading3.copyWith(
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your ingredients and let AI create amazing recipes for you.',
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.85),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Text('👨‍🍳', style: TextStyle(fontSize: 64)),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.kitchen_rounded,
              size: 20,
              color: AppTheme.primaryOrange,
            ),
            const SizedBox(width: 8),
            Text('Your Ingredients', style: AppTheme.heading3),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Type ingredients separated by commas',
          style: AppTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _ingredientController,
                focusNode: _focusNode,
                textCapitalization: TextCapitalization.words,
                onSubmitted: (_) => _addIngredient(),
                decoration: InputDecoration(
                  hintText: 'e.g. Chicken, Rice, Tomato',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppTheme.textHint,
                  ),
                  suffixIcon: _ingredientController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _ingredientController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 10),
            _AddIngredientButton(onPressed: _addIngredient),
          ],
        ),
      ],
    );
  }

  Widget _buildIngredientChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_ingredients.length} ingredient${_ingredients.length != 1 ? "s" : ""} added',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.primaryOrange,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_ingredients.length > 1)
              GestureDetector(
                onTap: () => setState(() => _ingredients.clear()),
                child: Text(
                  'Clear all',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.errorRed,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _ingredients
              .map(
                (ingredient) => IngredientChipWidget(
                  label: ingredient,
                  onRemove: () => _removeIngredient(ingredient),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildApiKeyNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No API key found. Demo recipes will be shown.\nSee README.md to configure your Groq API key.',
              style: AppTheme.bodySmall.copyWith(
                color: const Color(0xFF856404),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _generateRecipes,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryOrange,
          disabledBackgroundColor: AppTheme.primaryOrange.withOpacity(0.6),
          minimumSize: const Size(double.infinity, 58),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Our AI chef is cooking...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome_rounded, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Generate Recipes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _AddIngredientButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddIngredientButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryOrange.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}
