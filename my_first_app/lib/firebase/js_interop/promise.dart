import 'package:js/js.dart';

@JS('Promise')
class PromiseJsImpl<T> {
  external PromiseJsImpl(void Function(void Function(T) resolve, void Function(Object) reject) executor);
  external PromiseJsImpl then(void Function(T) onFulfilled, [void Function(Object) onRejected]);
} 