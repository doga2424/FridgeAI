@JS()
library firebase_auth_types;

import 'package:js/js.dart';
import 'promise.dart';

@JS('ActionCodeInfo')
class ActionCodeInfo {
  external String get email;
  external String get previousEmail;
}

@JS()
@anonymous
class AuthSettings {
  external factory AuthSettings({bool appVerificationDisabledForTesting});
  external bool get appVerificationDisabledForTesting;
}

@JS()
@anonymous
class IdTokenResult {
  external String get token;
  external dynamic get claims;
  external String get signInProvider;
  external int get expirationTime;
  external int get authTime;
  external int get issuedAtTime;
}

@JS()
@anonymous
class AdditionalUserInfo {
  external String? get providerId;
  external bool? get isNewUser;
  external String? get username;
  external dynamic get profile;
}

@JS()
@anonymous
class OAuthCredential extends AuthCredential {
  external String? get accessToken;
  external String? get idToken;
  external String? get rawNonce;
}

@JS()
@anonymous
class AuthCredential {
  external String get providerId;
  external String get signInMethod;
} 