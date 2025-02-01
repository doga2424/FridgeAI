import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS()
external dynamic Function(dynamic) get Promise;

Future<T> handleThenable<T>(dynamic thenable) {
  return promiseToFuture<T>(thenable);
}

@JS('Object')
external dynamic get Object;

@JS('JSON.stringify')
external String stringify(dynamic obj);

@JS('JSON.parse')
external dynamic parse(String str); 