import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// TODO: Uncomment when package is fixed
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:my_first_app/models/user_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String tokenKey = 'auth_token';
  static const String firstLoginKey = 'first_login_completed';

  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Initialize persistence
  Future<void> initializeAuth() async {
    await _auth.setPersistence(Persistence.LOCAL);
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create user document in Firestore
      await _db.collection('users').doc(credential.user!.uid).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential;
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign up
  Future<Map<String, dynamic>> signUp(String fullName, String email, String password) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user data in Firestore
      await _db.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Get ID token
      final token = await userCredential.user!.getIdToken();
      await _saveToken(token);

      return {
        'success': true,
        'data': {
          'id': userCredential.user!.uid,
          'fullName': fullName,
          'email': email,
          'token': token,
        }
      };
    } catch (e) {
      print('Signup error: $e');
      return {'success': false, 'message': _handleAuthError(e)};
    }
  }

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user data from Firestore
      final userData = await _db.collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // Get ID token
      final token = await userCredential.user!.getIdToken();
      await _saveToken(token);

      final isFirst = await isFirstLogin();
      
      return {
        'success': true,
        'data': {
          'id': userCredential.user!.uid,
          'fullName': userData.data()?['fullName'],
          'email': email,
          'token': token,
          'isFirstLogin': isFirst,
        }
      };
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'message': _handleAuthError(e)};
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // Save token
  Future<void> _saveToken(String? token) async {
    if (token == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // Get token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Modify the isFirstLogin method to always return true for development
  Future<bool> isFirstLogin() async {
    // For development: Always return true to show welcome screen
    return true;
    
    // Original implementation (commented out for now)
    // final prefs = await SharedPreferences.getInstance();
    // return !prefs.getBool(firstLoginKey) ?? true;
  }

  // Optional: You can also modify completeFirstLogin to do nothing during development
  Future<void> completeFirstLogin() async {
    // For development: Do nothing to keep showing welcome screen
    return;
    
    // Original implementation (commented out for now)
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool(firstLoginKey, true);
  }

  // Add this method to handle social login
  Future<Map<String, dynamic>> socialLogin(String provider, String token) async {
    try {
      UserCredential userCredential;
      
      switch (provider) {
        case 'google':
          final googleProvider = GoogleAuthProvider();
          userCredential = await _auth.signInWithPopup(googleProvider);
          break;
        case 'facebook':
          final facebookProvider = FacebookAuthProvider();
          userCredential = await _auth.signInWithPopup(facebookProvider);
          break;
        case 'apple':
          // TODO: Implement Apple sign in
          throw Exception('Apple sign in not implemented yet');
          // // Get Apple credentials
          // final appleCredential = await SignInWithApple.getAppleIDCredential(
          //   scopes: [
          //     AppleIDAuthorizationScopes.email,
          //     AppleIDAuthorizationScopes.fullName,
          //   ],
          // );
          
          // // Create OAuthCredential
          // final oauthCredential = OAuthProvider('apple.com').credential(
          //   idToken: appleCredential.identityToken,
          //   accessToken: appleCredential.authorizationCode,
          // );
          
          // // Sign in with Firebase
          // userCredential = await _auth.signInWithCredential(oauthCredential);
          break;
        default:
          throw Exception('Unsupported provider');
      }

      final token = await userCredential.user!.getIdToken();
      await _saveToken(token);

      final isFirst = await isFirstLogin();
      
      return {
        'success': true,
        'data': {
          'id': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'token': token,
          'isFirstLogin': isFirst,
        }
      };
    } catch (e) {
      print('Social login error: $e');
      return {'success': false, 'message': _handleAuthError(e)};
    }
  }

  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'Email is already registered';
        case 'invalid-email':
          return 'Invalid email address';
        case 'operation-not-allowed':
          return 'Operation not allowed';
        case 'weak-password':
          return 'Password is too weak';
        case 'user-disabled':
          return 'User has been disabled';
        case 'user-not-found':
          return 'User not found';
        case 'wrong-password':
          return 'Incorrect password';
        case 'invalid-credential':
          return 'Wrong email or password';
        default:
          return 'Authentication failed';
      }
    }
    return 'An error occurred';
  }

  Future<void> saveUserPreferences(UserPreferences preferences) async {
    try {
      final user = _auth.currentUser;
      
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Create user preferences document
      final userPrefsData = {
        'userId': user.uid,
        'email': user.email,
        'preferences': {
          'gender': preferences.gender,
          'ageRange': preferences.ageRange,
          'allergies': preferences.allergies,
          'dietaryPreferences': preferences.dietaryPreferences,
          'basicTastes': preferences.basicTastes,
          'fitnessGoals': preferences.fitnessGoals,
        },
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      // Check if user document exists
      final userDoc = await _db.collection('users').doc(user.uid).get();
      
      if (userDoc.exists) {
        // Update existing document
        await _db.collection('users').doc(user.uid).update(userPrefsData);
        print('Updated preferences for user: ${user.uid}');
      } else {
        // Create new document
        await _db.collection('users').doc(user.uid).set(userPrefsData);
        print('Created preferences for user: ${user.uid}');
      }

    } catch (e) {
      print('Error saving preferences: $e');
      throw Exception('Failed to save preferences: $e');
    }
  }

  // Add method to get user preferences
  Future<UserPreferences?> getUserPreferences() async {
    try {
      final user = _auth.currentUser;
      
      if (user == null) {
        return null;
      }

      final doc = await _db.collection('users').doc(user.uid).get();
      
      if (!doc.exists || !doc.data()!.containsKey('preferences')) {
        return null;
      }

      final prefsData = doc.data()!['preferences'] as Map<String, dynamic>;
      
      return UserPreferences(
        gender: prefsData['gender'] ?? '',
        ageRange: prefsData['ageRange'] ?? '',
        allergies: List<String>.from(prefsData['allergies'] ?? []),
        dietaryPreferences: List<String>.from(prefsData['dietaryPreferences'] ?? []),
        basicTastes: List<String>.from(prefsData['basicTastes'] ?? []),
        fitnessGoals: List<String>.from(prefsData['fitnessGoals'] ?? []),
      );
    } catch (e) {
      print('Error getting preferences: $e');
      return null;
    }
  }
} 