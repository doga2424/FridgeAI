@JS()
library firebase_firestore_interop;

import 'package:js/js.dart';
import 'promise.dart';

@JS('firebase.firestore.Firestore')
class FirestoreJsImpl {
  external CollectionReferenceJsImpl collection(String collectionPath);
  external DocumentReferenceJsImpl doc(String documentPath);
  external PromiseJsImpl<void> enablePersistence([PersistenceSettings? settings]);
}

@JS()
@anonymous
class DocumentReferenceJsImpl {
  external String get id;
  external String get path;
  external CollectionReferenceJsImpl collection(String collectionPath);
  external PromiseJsImpl<DocumentSnapshotJsImpl> get();
  external PromiseJsImpl<void> set(dynamic data, [dynamic options]);
  external PromiseJsImpl<void> update(dynamic data);
  external PromiseJsImpl<void> delete();
}

@JS()
@anonymous
class CollectionReferenceJsImpl {
  external String get id;
  external String get path;
  external DocumentReferenceJsImpl doc([String? documentPath]);
  external PromiseJsImpl<QuerySnapshotJsImpl> get();
  external PromiseJsImpl<DocumentReferenceJsImpl> add(dynamic data);
}

@JS()
@anonymous
class DocumentSnapshotJsImpl {
  external String get id;
  external bool get exists;
  external dynamic data();
  external dynamic get(String fieldPath);
}

@JS()
@anonymous
class QuerySnapshotJsImpl {
  external List<DocumentSnapshotJsImpl> get docs;
  external bool get empty;
  external int get size;
}

@JS()
@anonymous
class PersistenceSettings {
  external factory PersistenceSettings({bool synchronizeTabs});
} 