import 'package:flutter/material.dart';
import 'package:my_first_app/login_page.dart';
import 'package:my_first_app/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fridge App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: Color(0xFF10B981), // Emerald color
          secondary: Color(0xFF10B981),
          surface: Colors.white,
          background: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF10B981), // Emerald color
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        useMaterial3: true,
      ),
      home: LoginPage(),
      routes: {
        '/home': (context) => HomePage(),
      },
    );
  }
}
