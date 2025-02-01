import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_first_app/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/providers/theme_provider.dart';
import 'package:my_first_app/pages/profile_page.dart';
import 'package:my_first_app/widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authService = AuthService();
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  final List<Widget> _pages = [
    Center(child: Text('Home')),  // Replace with your actual home page
    Center(child: Text('Inventory')),  // Replace with your inventory page
    Center(child: Text('Scan')),  // Replace with your scan page
    Center(child: Text('Shopping')),  // Replace with your shopping page
    ProfilePage(),  // Your existing profile page
  ];

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

  void _onItemTapped(int index) {
    if (index == 2) {  // Camera/Scan button
      // Handle camera functionality
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          _pages[_selectedIndex],
          
          // Camera button
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: () {
                  // Handle camera functionality
                },
                child: Icon(Icons.camera_alt),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          
          // Bottom navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildInventoryPage();
      case 2:
        return _buildShoppingListPage();
      case 3:
        return ProfilePage();
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
} 