import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_first_app/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/providers/theme_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authService = AuthService();
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  IconData _getThemeIcon(BuildContext context) {
    final themeMode = Provider.of<ThemeProvider>(context).themeMode;
    switch (themeMode) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }

  String _getThemeTooltip(BuildContext context) {
    final themeMode = Provider.of<ThemeProvider>(context).themeMode;
    switch (themeMode) {
      case ThemeMode.system:
        return 'Use Device Theme';
      case ThemeMode.light:
        return 'Switch to Dark Mode';
      case ThemeMode.dark:
        return 'Switch to System Theme';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Fridge'),
        actions: [
          IconButton(
            icon: Icon(_getThemeIcon(context)),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            tooltip: _getThemeTooltip(context),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Navigation Rail
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2),
                label: Text('Inventory'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_cart_outlined),
                selectedIcon: Icon(Icons.shopping_cart),
                label: Text('Shopping List'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
          ),
          // Main content
          Expanded(
            child: Container(
              color: colorScheme.surface,
              child: _buildPage(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildInventoryPage();
      case 2:
        return _buildShoppingListPage();
      case 3:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/fridge.svg',
            width: 200,
            height: 200,
          ),
          SizedBox(height: 20),
          Text(
            'Welcome to Your Smart Fridge!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryPage() {
    return Center(
      child: Text('Inventory Page - Coming Soon'),
    );
  }

  Widget _buildShoppingListPage() {
    return Center(
      child: Text('Shopping List Page - Coming Soon'),
    );
  }

  Widget _buildProfilePage() {
    return Center(
      child: Text('Profile Page - Coming Soon'),
    );
  }
} 