import 'package:js/js.dart';
import '../utils/js_interop_utils.dart';
import 'js_interop/promise.dart';
import 'js_interop/core_interop.dart';
import 'js_interop/auth_interop.dart';
import 'js_interop/auth_types.dart';
import 'js_interop/firestore_interop.dart';

@JS('firebase.auth')
external AuthJsImpl get auth;

@JS('firebase.firestore')
external FirestoreJsImpl get firestore;

@JS()
@anonymous
class AuthResult {
  external dynamic get user;
}

@JS()
@anonymous
class UserCredential {
  external dynamic get user;
}

@JS()
@anonymous
class UserJsImpl {
  external String get uid;
  external String get email;
  external PromiseJsImpl<void> delete();
  external PromiseJsImpl<String> getIdToken([bool? forceRefresh]);
}

class FirebaseWebInterop {
  static Future<UserCredentialJsImpl> signInWithEmailAndPassword(String email, String password) {
    return handleThenable(auth.signInWithEmailAndPassword(email, password));
  }

  static Future<void> signOut() {
    return handleThenable(auth.signOut());
  }

  static Future<DocumentSnapshotJsImpl> getDocument(String path) {
    return handleThenable(firestore.doc(path).get());
  }

  static Future<void> setDocument(String path, dynamic data) {
    return handleThenable(firestore.doc(path).set(jsify(data)));
  }

  static Future<QuerySnapshotJsImpl> getCollection(String path) {
    return handleThenable(firestore.collection(path).get());
  }

  static dynamic jsifyUser(UserJsImpl user) {
    return jsify({
      'uid': user.uid,
      'email': user.email,
      'emailVerified': user.emailVerified,
      'isAnonymous': user.isAnonymous,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'phoneNumber': user.phoneNumber,
    });
  }

  static UserJsImpl dartifyUser(dynamic jsUser) {
    return dartify(jsUser) as UserJsImpl;
  }
} 