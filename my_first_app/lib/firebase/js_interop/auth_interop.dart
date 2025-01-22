@JS()
library firebase_auth_interop;

import 'package:js/js.dart';
import 'promise.dart';
import 'auth_types.dart';

@JS('firebase.auth.Auth')
class AuthJsImpl {
  external AuthJsImpl();
  external PromiseJsImpl<UserCredentialJsImpl> signInWithEmailAndPassword(String email, String password);
  external PromiseJsImpl<void> signOut();
  external PromiseJsImpl<void> applyActionCode(String code);
  external PromiseJsImpl<ActionCodeInfo> checkActionCode(String code);
  external PromiseJsImpl<void> confirmPasswordReset(String code, String newPassword);
  external PromiseJsImpl<void> setPersistence(String persistence);
  external PromiseJsImpl<UserCredentialJsImpl> createUserWithEmailAndPassword(String email, String password);
  external PromiseJsImpl<void> sendPasswordResetEmail(String email, [dynamic actionCodeSettings]);
  external PromiseJsImpl<void> verifyPasswordResetCode(String code);
}

@JS()
@anonymous
class UserCredentialJsImpl {
  external UserJsImpl get user;
  external AdditionalUserInfo? get additionalUserInfo;
  external OAuthCredential? get credential;
  external String get operationType;
}

@JS()
@anonymous
class UserJsImpl {
  external String get uid;
  external String? get email;
  external bool get emailVerified;
  external bool get isAnonymous;
  external List<UserInfo> get providerData;
  external String? get displayName;
  external String? get photoURL;
  external String? get phoneNumber;
  external bool get isEmailVerified;
  external String get tenantId;
  external PromiseJsImpl<void> delete();
  external PromiseJsImpl<String> getIdToken([bool? forceRefresh]);
  external PromiseJsImpl<IdTokenResult> getIdTokenResult([bool? forceRefresh]);
  external PromiseJsImpl<void> reload();
  external PromiseJsImpl<void> sendEmailVerification([dynamic actionCodeSettings]);
  external PromiseJsImpl<void> updateEmail(String newEmail);
  external PromiseJsImpl<void> updatePassword(String newPassword);
  external PromiseJsImpl<void> updatePhoneNumber(AuthCredential phoneCredential);
  external PromiseJsImpl<void> updateProfile(dynamic profile);
  external PromiseJsImpl<void> verifyBeforeUpdateEmail(String newEmail, [dynamic actionCodeSettings]);
}

@JS()
@anonymous
class UserInfo {
  external String get displayName;
  external String get email;
  external String get phoneNumber;
  external String get photoURL;
  external String get providerId;
  external String get uid;
}

@JS('firebase.auth.EmailAuthProvider')
class EmailAuthProviderJsImpl {
  external static CredentialJsImpl credential(String email, String password);
}

@JS()
@anonymous
class CredentialJsImpl {
  external String get providerId;
  external String get signInMethod;
} 