@JS('firebase')
library firebase_interop;

import 'package:js/js.dart';
import 'promise.dart';

@JS('auth')
external AuthJsImpl get auth;

@JS('firestore')
external FirestoreJsImpl get firestore;

@JS()
@anonymous
class AuthJsImpl {
  external PromiseJsImpl<UserCredentialJsImpl> signInWithEmailAndPassword(String email, String password);
  external PromiseJsImpl<void> signOut();
}

@JS()
@anonymous
class UserCredentialJsImpl {
  external UserJsImpl get user;
}

@JS()
@anonymous
class UserJsImpl {
  external String get uid;
  external String? get email;
  external bool get emailVerified;
}

@JS()
@anonymous
class FirestoreJsImpl {
  external CollectionReferenceJsImpl collection(String collectionPath);
  external DocumentReferenceJsImpl doc(String documentPath);
}

@JS()
@anonymous
class DocumentReferenceJsImpl {
  external PromiseJsImpl<DocumentSnapshotJsImpl> get();
  external PromiseJsImpl<void> set(dynamic data);
}

@JS()
@anonymous
class CollectionReferenceJsImpl {
  external PromiseJsImpl<QuerySnapshotJsImpl> get();
}

@JS()
@anonymous
class DocumentSnapshotJsImpl {
  external bool get exists;
  external dynamic data();
}

@JS()
@anonymous
class QuerySnapshotJsImpl {
  external List<DocumentSnapshotJsImpl> get docs;
} 