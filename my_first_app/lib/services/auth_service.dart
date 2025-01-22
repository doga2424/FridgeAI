import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String tokenKey = 'auth_token';

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

      return {
        'success': true,
        'data': {
          'id': userCredential.user!.uid,
          'fullName': userData.data()?['fullName'],
          'email': email,
          'token': token,
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

  // Add this method to handle social login
  Future<Map<String, dynamic>> socialLogin(String provider, String token) async {
    try {
      UserCredential userCredential;
      
      switch (provider) {
        case 'google':
          final googleProvider = GoogleAuthProvider();
          userCredential = await _auth.signInWithPopup(googleProvider);
          break;
        case 'github':
          final githubProvider = GithubAuthProvider();
          userCredential = await _auth.signInWithPopup(githubProvider);
          break;
        case 'facebook':
          final facebookProvider = FacebookAuthProvider();
          userCredential = await _auth.signInWithPopup(facebookProvider);
          break;
        default:
          throw Exception('Unsupported provider');
      }

      final token = await userCredential.user!.getIdToken();
      await _saveToken(token);

      return {
        'success': true,
        'data': {
          'id': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'token': token,
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
} 