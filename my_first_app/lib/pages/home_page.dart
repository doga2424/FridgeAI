import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_first_app/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/providers/theme_provider.dart';
import 'package:my_first_app/pages/profile_page.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                Expanded(
                  child: _buildPage(_selectedIndex),
                ),
              ],
            ),
            
            // Bottom navigation
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: bottomNavigationBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomNavigationBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        tooltipTheme: TooltipThemeData(
          textStyle: TextStyle(fontSize: 0),
          height: 0,
          padding: EdgeInsets.zero,
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              );
            }
            return TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 12,
            );
          }),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          NavigationBar(
            height: 65,
            backgroundColor: Theme.of(context).colorScheme.surface,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            selectedIndex: _selectedIndex >= 2 ? _selectedIndex + 1 : _selectedIndex,
            destinations: [
              NavigationDestination(
                icon: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 0 
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
                      : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 2,
                        width: 24,
                        decoration: BoxDecoration(
                          color: _selectedIndex == 0 
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.9)
                            : Colors.transparent,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      SizedBox(height: 4),
                      Icon(
                        Icons.home_outlined,
                        size: 24,
                        color: _selectedIndex == 0 
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Home',
                        style: TextStyle(
                          color: _selectedIndex == 0
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                label: '',
              ),
              NavigationDestination(
                icon: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 1 
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
                      : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 2,
                        width: 24,
                        decoration: BoxDecoration(
                          color: _selectedIndex == 1 
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.9)
                            : Colors.transparent,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      SizedBox(height: 4),
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 24,
                        color: _selectedIndex == 1 
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Inventory',
                        style: TextStyle(
                          color: _selectedIndex == 1
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                label: '',
              ),
              NavigationDestination(
                icon: SizedBox(height: 24),
                label: '',
              ),
              NavigationDestination(
                icon: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 2 
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
                      : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 2,
                        width: 24,
                        decoration: BoxDecoration(
                          color: _selectedIndex == 2 
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.9)
                            : Colors.transparent,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      SizedBox(height: 4),
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 24,
                        color: _selectedIndex == 2 
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Shopping',
                        style: TextStyle(
                          color: _selectedIndex == 2
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                label: '',
              ),
              NavigationDestination(
                icon: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 3 
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
                      : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 2,
                        width: 24,
                        decoration: BoxDecoration(
                          color: _selectedIndex == 3 
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.9)
                            : Colors.transparent,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      SizedBox(height: 4),
                      Icon(
                        Icons.person_outline,
                        size: 24,
                        color: _selectedIndex == 3 
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Profile',
                        style: TextStyle(
                          color: _selectedIndex == 3
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                label: '',
              ),
            ],
            onDestinationSelected: (int index) {
              if (index == 2) {
                _handleCameraPress();
                return;
              }
              setState(() {
                _selectedIndex = index > 2 ? index - 1 : index;
              });
            },
          ),
          Positioned(
            top: 4,
            child: GestureDetector(
              onTap: _handleCameraPress,
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 24,
                ),
              ),
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