import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Single import for all Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_first_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/providers/language_provider.dart';
import 'package:my_first_app/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _isLoading = true;
  String _name = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() => _isLoading = true);
      
      final user = _auth.currentUser;
      if (user != null) {
        final userData = await _db.collection('users').doc(user.uid).get();
        
        setState(() {
          _name = userData.data()?['fullName'] ?? 'No name set';
          _email = user.email ?? 'No email set';
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _editProfile() {
    final TextEditingController nameController = TextEditingController(text: _name);
    final TextEditingController emailController = TextEditingController(text: _email);
    bool isSaving = false;

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).editProfile,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),

                // Name Input with current name as initial value
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).name,
                    hintText: _name.isEmpty 
                        ? AppLocalizations.of(context).enterYourName 
                        : _name,  // Show current name as placeholder
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                SizedBox(height: 16),

                // Email Input (disabled)
                TextField(
                  controller: emailController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).email,
                    hintText: _email,  // Show current email
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.light 
                        ? Colors.grey[100] 
                        : Colors.grey[800],
                  ),
                ),
                SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppLocalizations.of(context).cancel,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () async {
                              setState(() => isSaving = true);
                              try {
                                final user = _auth.currentUser;
                                if (user != null) {
                                  await _db.collection('users').doc(user.uid).update({
                                    'fullName': nameController.text.trim(),
                                  });
                                  Navigator.pop(context);
                                  _loadUserData();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(AppLocalizations.of(context).profileUpdated),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context).errorUpdating + ': $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                setState(() => isSaving = false);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isSaving
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context).save,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _changePassword(String currentPassword, String newPassword) async {
    try {
      // Get current user
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw Exception('No user logged in');
      }

      // First verify current password by signing in again
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: user.email!,
        password: currentPassword,
      );

      // If sign in was successful, update the password
      if (userCredential.user != null) {
        await userCredential.user!.updatePassword(newPassword);
      } else {
        throw Exception('Failed to authenticate');
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('General Error: $e');
      rethrow;
    }
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isChanging = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).changePassword,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                
                // Current Password
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).currentPassword,
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                
                // New Password
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).newPassword,
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                
                // Confirm New Password
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).confirmPassword,
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppLocalizations.of(context).cancel,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isChanging
                          ? null
                          : () async {
                              if (newPasswordController.text != confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context).passwordsDoNotMatch),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              
                              setState(() => isChanging = true);
                              try {
                                await _changePassword(
                                  currentPasswordController.text,
                                  newPasswordController.text,
                                );
                                
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context).passwordChanged),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } on FirebaseAuthException catch (e) {
                                String errorMessage = 'An error occurred';
                                switch (e.code) {
                                  case 'wrong-password':
                                    errorMessage = 'Current password is incorrect';
                                    break;
                                  case 'weak-password':
                                    errorMessage = 'New password is too weak';
                                    break;
                                  case 'requires-recent-login':
                                    errorMessage = 'Please log out and log in again before changing password';
                                    break;
                                  default:
                                    errorMessage = e.message ?? 'An error occurred';
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${AppLocalizations.of(context).errorChangingPassword}: $errorMessage'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${AppLocalizations.of(context).errorChangingPassword}: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                if (mounted) {
                                  setState(() => isChanging = false);
                                }
                              }
                            },
                      child: isChanging
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(AppLocalizations.of(context).save),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageSettings() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).language,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              
              // Language Options
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('English'),
                leading: Radio<String>(
                  value: 'en',
                  groupValue: Provider.of<LanguageProvider>(context).locale.languageCode,
                  onChanged: (value) {
                    Provider.of<LanguageProvider>(context, listen: false)
                        .setLocale(Locale(value!));
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Türkçe'),
                leading: Radio<String>(
                  value: 'tr',
                  groupValue: Provider.of<LanguageProvider>(context).locale.languageCode,
                  onChanged: (value) {
                    Provider.of<LanguageProvider>(context, listen: false)
                        .setLocale(Locale(value!));
                    Navigator.pop(context);
                  },
                ),
              ),
              
              // Close Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppLocalizations.of(context).close,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
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

  // Update the _showLogoutConfirmation method
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).logoutConfirmation),
        content: Text(AppLocalizations.of(context).logoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          TextButton(
            onPressed: () async {
              try {
                Navigator.pop(context);  // Close the dialog first
                
                // Sign out from Firebase
                await _auth.signOut();
                
                // Clear any stored preferences EXCEPT has_seen_welcome
                final prefs = await SharedPreferences.getInstance();
                final hasSeenWelcome = prefs.getBool('has_seen_welcome') ?? false;
                await prefs.clear();
                await prefs.setBool('has_seen_welcome', hasSeenWelcome);  // Preserve this value
                
                // Navigate to root which will show login page since user is logged out
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (Route<dynamic> route) => false,
                  );
                }
              } catch (e) {
                print('Error during logout: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error logging out: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(
              AppLocalizations.of(context).logout,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 48),  // Add top margin for status bar
                  // User Info Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: 60,
                      bottom: 40,
                      left: 24,
                      right: 24,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            _name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _email,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // App Settings Section
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.appSettings,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.dark_mode_outlined, color: Theme.of(context).colorScheme.primary),
                                title: Text(localizations.darkMode),
                                trailing: Switch(
                                  value: Theme.of(context).brightness == Brightness.dark,
                                  onChanged: (value) {
                                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                                  },
                                  activeColor: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Divider(height: 1),
                              ListTile(
                                leading: Icon(Icons.language, color: Theme.of(context).colorScheme.primary),
                                title: Text(localizations.language),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: _showLanguageSettings,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24),
                        
                        // Account Settings
                        Text(
                          localizations.accountSettings,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                                title: Text(localizations.editProfile),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: _editProfile,
                              ),
                              Divider(height: 1),
                              ListTile(
                                leading: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.primary),
                                title: Text(localizations.changePassword),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: _showChangePasswordDialog,
                              ),
                              Divider(height: 1),
                              ListTile(
                                leading: Icon(Icons.notifications, color: Theme.of(context).colorScheme.primary),
                                title: Text(localizations.notifications),
                                trailing: Switch(
                                  value: true,
                                  onChanged: (value) {
                                    // Implement notification settings
                                  },
                                  activeColor: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Divider(height: 1),
                              ListTile(
                                leading: Icon(Icons.security, color: Theme.of(context).colorScheme.primary),
                                title: Text(localizations.privacySecurity),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  // Implement privacy settings
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24),

                        // Help & Support
                        Text(
                          localizations.helpSupport,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.help_outline, color: Theme.of(context).colorScheme.primary),
                                title: Text(localizations.faq),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  // Implement FAQ navigation
                                },
                              ),
                              Divider(height: 1),
                              ListTile(
                                leading: Icon(Icons.support_agent_outlined, color: Theme.of(context).colorScheme.primary),
                                title: Text(localizations.contactSupport),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  // Implement support contact
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24),

                        // Logout Button
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.logout, color: Colors.red),
                            title: Text(
                              localizations.logout,
                              style: TextStyle(color: Colors.red),
                            ),
                            onTap: _showLogoutConfirmation,
                          ),
                        ),
                        
                        SizedBox(height: 80), // Increased from 32 to 80 to account for the navigation bar
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
} 