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

  void _handleCameraPress() {
    print('Camera button pressed');
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
            tooltip: '',
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            tooltip: '',
          ),
        ],
      ),
      body: _buildPage(_selectedIndex),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          tooltipTheme: TooltipThemeData(
            textStyle: TextStyle(fontSize: 0),
            height: 0,
            padding: EdgeInsets.zero,
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            NavigationBar(
              height: 65,
              backgroundColor: Theme.of(context).colorScheme.surface,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: <NavigationDestination>[
                NavigationDestination(
                  icon: Icon(Icons.home_outlined, size: 24),
                  selectedIcon: Icon(Icons.home, size: 24),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined, size: 24),
                  selectedIcon: Icon(Icons.inventory_2, size: 24),
                  label: 'Inventory',
                ),
                NavigationDestination(
                  icon: SizedBox(height: 24),
                  label: '',
                ),
                NavigationDestination(
                  icon: Icon(Icons.shopping_cart_outlined, size: 24),
                  selectedIcon: Icon(Icons.shopping_cart, size: 24),
                  label: 'Shopping List',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline, size: 24),
                  selectedIcon: Icon(Icons.person, size: 24),
                  label: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                if (index == 2) {
                  _handleCameraPress();
                  return;
                }
                final adjustedIndex = index > 2 ? index - 1 : index;
                setState(() {
                  _selectedIndex = adjustedIndex;
                });
              },
            ),
            Positioned(
              top: 8,
              child: GestureDetector(
                onTap: _handleCameraPress,
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    final adjustedIndex = index > 2 ? index - 1 : index;
    switch (adjustedIndex) {
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