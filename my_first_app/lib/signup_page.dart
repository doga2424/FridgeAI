import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_first_app/services/auth_service.dart';
import 'package:my_first_app/widgets/loading_overlay.dart';
import 'login_page.dart';
import 'utils/page_transition.dart';

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
      final result = await _authService.signUp(_name, _email, _password);
      
      if (result['success']) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Signup failed';
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

    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Row(
            children: [
              // Left side - Sign Up Form
              Expanded(
                child: Container(
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
                        'Get Started!',
                        style: textTheme.bodyMedium,
                      ),
                      
                      // Sign Up Text
                      Text(
                        'Create Account',
                        style: textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      SizedBox(height: 40),
                      
                      // Sign Up Form
                      Form(
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
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              onSaved: (value) => _password = value!,
                            ),
                            
                            SizedBox(height: 30),
                            
                            // Sign Up Button
                            ElevatedButton(
                              onPressed: _handleSignup,
                              child: Text('SIGN UP'),
                            ),
                            
                            SizedBox(height: 20),
                            
                            // Or continue with
                            Row(
                              children: [
                                Expanded(child: Divider(color: colorScheme.onSurface.withOpacity(0.2))),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'or continue with',
                                    style: textTheme.bodyMedium,
                                  ),
                                ),
                                Expanded(child: Divider(color: colorScheme.onSurface.withOpacity(0.2))),
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
                                  'assets/images/apple.svg',
                                  () => _handleSocialSignup('apple'),
                                ),
                                SizedBox(width: 20),
                                _socialLoginButton(
                                  'assets/images/facebook.svg',
                                  () => _handleSocialSignup('facebook'),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 20),
                            
                            // Login link
                            Row(
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
                                      SmoothPageTransition(LoginPage()),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Right side - Illustration
              Expanded(
                child: Hero(
                  tag: 'illustration',
                  child: Container(
                    color: colorScheme.surface,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/fridge.svg',
                        width: 400,
                        height: 400,
                        fit: BoxFit.contain,
                      ),
                    ),
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
          colorFilter: iconPath.contains('apple') 
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