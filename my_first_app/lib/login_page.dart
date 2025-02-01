import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_first_app/services/auth_service.dart';
import 'package:my_first_app/widgets/loading_overlay.dart';
import 'signup_page.dart';
import 'utils/page_transition.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _errorMessage = '';
  String _email = '';
  String _password = '';
  bool _obscurePassword = true;
  
  // Animation controllers
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Add this focus node
  final FocusNode _passwordFocusNode = FocusNode();

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

    // Check if user is already signed in
    if (_authService.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
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
      final result = await _authService.login(_email, _password);
      
      if (result['success']) {
        if (result['data']['isFirstLogin']) {
          Navigator.of(context).pushReplacementNamed('/welcome');
        } else {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Login failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection error. Please check if the server is running.';
      });
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
        if (result['data']['isFirstLogin']) {
          Navigator.of(context).pushReplacementNamed('/welcome');
        } else {
          Navigator.of(context).pushReplacementNamed('/home');
        }
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 900;
              final contentWidth = isSmallScreen ? size.width : size.width * 0.4;
              final padding = isSmallScreen ? 20.0 : 40.0;

              return SingleChildScrollView(
                child: Container(
                  height: size.height,
                  child: isSmallScreen 
                    ? _buildLoginContent(
                        context, 
                        contentWidth, 
                        padding, 
                        isSmallScreen,
                        colorScheme,
                        textTheme,
                      )
                    : Row(
                        children: [
                          _buildLoginContent(
                            context, 
                            contentWidth, 
                            padding, 
                            isSmallScreen,
                            colorScheme,
                            textTheme,
                          ),
                          Expanded(
                            child: Hero(
                              tag: 'illustration',
                              child: Container(
                                color: colorScheme.surface,
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/images/fridge.svg',
                                    width: size.width * 0.3,
                                    height: size.height * 0.5,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginContent(
    BuildContext context,
    double contentWidth,
    double padding,
    bool isSmallScreen,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      width: contentWidth,
      padding: EdgeInsets.all(padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Text(
            'Logo Here',
            style: textTheme.headlineMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 24 : 32,
            ),
          ),
          SizedBox(height: isSmallScreen ? 15 : 20),
          
          // Welcome Text
          Text(
            'Welcome back !!!',
            style: textTheme.bodyMedium?.copyWith(
              fontSize: isSmallScreen ? 14 : 16,
            ),
          ),
          
          // Log In Text
          Text(
            'Log In',
            style: textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 28 : 36,
            ),
          ),
          
          SizedBox(height: isSmallScreen ? 30 : 40),
          
          // Login Form
          Container(
            width: contentWidth,
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
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : 16,
                        vertical: isSmallScreen ? 12 : 16,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                    textInputAction: TextInputAction.next,
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
                  
                  SizedBox(height: isSmallScreen ? 15 : 20),
                  
                  // Password Field
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Password', style: textTheme.bodyLarge),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password
                        },
                        child: Text(
                          'Forgot Password?',
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    focusNode: _passwordFocusNode,
                    obscureText: _obscurePassword,
                    onFieldSubmitted: (_) => _handleLogin(),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : 16,
                        vertical: isSmallScreen ? 12 : 16,
                      ),
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
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value!,
                  ),
                  
                  SizedBox(height: isSmallScreen ? 20 : 30),
                  
                  // Login Button
                  SizedBox(
                    height: isSmallScreen ? 45 : 50,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                    ),
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
                        () => _handleSocialLogin('google'),
                      ),
                      SizedBox(width: 20),
                      _socialLoginButton(
                        'assets/images/apple.svg',
                        () => _handleSocialLogin('apple'),
                      ),
                      SizedBox(width: 20),
                      _socialLoginButton(
                        'assets/images/facebook.svg',
                        () => _handleSocialLogin('facebook'),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account yet? ",
                        style: textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            SmoothPageTransition(SignupPage()),
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
                ],
              ),
            ),
          ),
        ],
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