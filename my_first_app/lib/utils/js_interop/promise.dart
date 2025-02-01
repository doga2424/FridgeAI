@JS('Promise')
class PromiseJsImpl<T> {
  external PromiseJsImpl(void Function(void Function(T) resolve, void Function(Object) reject) executor);
  external PromiseJsImpl<S> then<S>(S Function(T) onFulfilled, [Function onRejected]);
}

Future<T> handleThenable<T>(dynamic thenable) {
  return promiseToFuture<T>(thenable);
} 