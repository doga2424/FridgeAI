@JS()
library firebase_interop;

import 'package:js/js.dart';

@JS('Object.keys')
external List<String> objectKeys(dynamic obj);

dynamic dartify(dynamic jsObject) {
  return jsObject;
}

dynamic jsify(dynamic dartObject, [dynamic Function(dynamic)? customJsify]) {
  return dartObject;
} 