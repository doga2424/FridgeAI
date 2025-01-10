import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_first_app/services/auth_service.dart';
import 'package:my_first_app/widgets/loading_overlay.dart';
import 'signup_page.dart';
import 'utils/page_transition.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_app/widgets/fridge_illustration.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    print('Creating LoginPage state');
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _isLoading = false;
  String _errorMessage = '';
  String _email = '';
  String _password = '';
  bool _obscurePassword = true;
  
  // Animation controllers
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    _formKey.currentState!.save();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': _email.trim(),
          'password': _password.trim(),
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Login successful
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Login failed
        setState(() {
          _errorMessage = responseData['message'] ?? 'Login failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection error. Please try again.';
      });
      print('Login error: $e'); // For debugging
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // TODO: Implement social login
      final result = await _authService.socialLogin(provider, 'token');
      
      if (result['success']) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Social login failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection error. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final showFridge = screenWidth > 768;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Row(
            children: [
              // Left side - Login Form
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      Text(
                        'Logo Here',
                        style: textTheme.headlineMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Welcome Text
                      Text(
                        'Welcome back !!!',
                        style: textTheme.bodyMedium,
                      ),
                      
                      // Log In Text
                      Text(
                        'Log In',
                        style: textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      SizedBox(height: 40),
                      
                      // Form in a scrollable container
                      Expanded(
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (_errorMessage.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 16),
                                    child: Text(
                                      _errorMessage,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),

                                // Email Field
                                Text('Email', style: textTheme.bodyLarge),
                                SizedBox(height: 8),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'login@gmail.com',
                                    border: OutlineInputBorder(),
                                  ),
                                  onSaved: (value) => _email = value ?? '',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),

                                // Password Field
                                Text('Password', style: textTheme.bodyLarge),
                                SizedBox(height: 8),
                                TextFormField(
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your password',
                                    border: OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  onSaved: (value) => _password = value ?? '',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 40),

                                // Login Button
                                ElevatedButton(
                                  onPressed: _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF10B981),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),

                                // Or continue with
                                Row(
                                  children: [
                                    Expanded(child: Divider()),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      child: Text('or continue with'),
                                    ),
                                    Expanded(child: Divider()),
                                  ],
                                ),
                                SizedBox(height: 20),

                                // Social Login Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _socialLoginButton(
                                      'assets/images/google.svg',
                                      () => _handleSocialLogin('google'),
                                    ),
                                    SizedBox(width: 20),
                                    _socialLoginButton(
                                      'assets/images/github.svg',
                                      () => _handleSocialLogin('github'),
                                    ),
                                    SizedBox(width: 20),
                                    _socialLoginButton(
                                      'assets/images/facebook.svg',
                                      () => _handleSocialLogin('facebook'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Sign up link at the bottom
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account yet? ",
                              style: textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => SignupPage(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                    transitionDuration: Duration(milliseconds: 500),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign up for free',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Right side - Illustration
              if (showFridge)
                Expanded(
                  child: Center(
                    child: FridgeIllustration(
                      screenWidth: screenWidth,
                      timestamp: DateTime.now(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialLoginButton(String iconPath, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.asset(
          iconPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
} 