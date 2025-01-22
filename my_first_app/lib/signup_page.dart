import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_first_app/services/auth_service.dart';
import 'package:my_first_app/widgets/loading_overlay.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';
import 'utils/page_transition.dart';
import 'dart:convert';
import 'dart:io';
import 'package:my_first_app/widgets/fridge_illustration.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _isLoading = false;
  String _errorMessage = '';
  String _name = '';
  String _email = '';
  String _password = '';
  bool _obscurePassword = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Add these focus nodes
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    _formKey.currentState!.save();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'fullName': _name.trim(),
          'email': _email.trim(),
          'password': _password.trim(),
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        try {
          final responseData = json.decode(response.body);
          if (responseData['success'] == true) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else {
            setState(() {
              _errorMessage = responseData['message'] ?? 'Signup failed';
            });
          }
        } catch (e) {
          print('JSON decode error: $e');
          setState(() {
            _errorMessage = 'Invalid server response';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      print('Error details: $e');
      setState(() {
        _errorMessage = 'Connection error. Please check if the server is running.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSocialSignup(String provider) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // TODO: Implement social signup
      final result = await _authService.socialLogin(provider, 'token');
      
      if (result['success']) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Social signup failed';
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
              // Left side - Signup Form
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
                      
                      // Get Started Text
                      Text(
                        'Get Started!',
                        style: textTheme.bodyMedium,
                      ),
                      
                      // Create Account Text
                      Text(
                        'Create Account',
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

                                // Full Name Field
                                Text('Full Name', style: textTheme.bodyLarge),
                                SizedBox(height: 8),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Enter your full name',
                                    border: OutlineInputBorder(),
                                  ),
                                  onSaved: (value) => _name = value ?? '',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),

                            // Full Name Field
                            Text('Full Name', style: textTheme.bodyLarge),
                            SizedBox(height: 8),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter your full name',
                              ),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_emailFocusNode);
                              },
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              onSaved: (value) => _name = value!,
                            ),
                            
                            SizedBox(height: 20),
                            
                            // Email Field
                            Text('Email', style: textTheme.bodyLarge),
                            SizedBox(height: 8),
                            TextFormField(
                              focusNode: _emailFocusNode,
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                              ),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_passwordFocusNode);
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              onSaved: (value) => _email = value!,
                            ),
                            
                            SizedBox(height: 20),
                            
                            // Password Field
                            Text('Password', style: textTheme.bodyLarge),
                            SizedBox(height: 8),
                            TextFormField(
                              focusNode: _passwordFocusNode,
                              obscureText: _obscurePassword,
                              onFieldSubmitted: (_) => _handleSignup(),
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintText: 'Create a password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: colorScheme.onSurface.withOpacity(0.6),
                                // Email Field
                                Text('Email', style: textTheme.bodyLarge),
                                SizedBox(height: 8),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Enter your email',
                                    border: OutlineInputBorder(),
                                  ),
                                  onSaved: (value) => _email = value ?? '',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Please enter a valid email';
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
                                    hintText: 'Create a password',
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
                                      return 'Please enter a password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 40),

                                // Sign Up Button
                                ElevatedButton(
                                  onPressed: _handleSignup,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF10B981),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'SIGN UP',
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
                                      () => _handleSocialSignup('google'),
                                    ),
                                    SizedBox(width: 20),
                                    _socialLoginButton(
                                      'assets/images/github.svg',
                                      () => _handleSocialSignup('github'),
                                    ),
                                    SizedBox(width: 20),
                                    _socialLoginButton(
                                      'assets/images/facebook.svg',
                                      () => _handleSocialSignup('facebook'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Login link at the bottom
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
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
                                'Login here',
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
          colorFilter: iconPath.contains('github') 
              ? ColorFilter.mode(
                  isDark ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                )
              : null,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
} 