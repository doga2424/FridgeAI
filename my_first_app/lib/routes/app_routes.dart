import 'package:flutter/material.dart';
import 'package:my_first_app/pages/home_page.dart';
import 'package:my_first_app/login_page.dart';
import 'package:my_first_app/signup_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    '/login': (context) => LoginPage(),
    '/signup': (context) => SignupPage(),
    '/home': (context) => HomePage(),
  };

  static String get initialRoute => '/login';
} 