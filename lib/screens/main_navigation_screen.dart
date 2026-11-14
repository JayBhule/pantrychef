import 'package:flutter/material.dart';
import '../services/groq_service.dart';
import '../utils/app_theme.dart';
import 'home_screen.dart';
import 'favourites_screen.dart';

/// Main navigation shell that holds the bottom navigation bar.
/// Manages switching between Home and Favourites tabs.
class MainNavigationScreen extends StatefulWidget {
  final GroqService groqService;

  const MainNavigationScreen({super.key, required this.groqService});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Screens are built once and kept alive when switching tabs
    _screens = [
      HomeScreen(groqService: widget.groqService),
      const FavouritesScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
            },
            backgroundColor: AppTheme.surfaceWhite,
            elevation: 0,
            indicatorColor: AppTheme.primaryOrange.withOpacity(0.12),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_outline_rounded),
                selectedIcon: Icon(Icons.favorite_rounded),
                label: 'Favourites',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
