Future<R> requestApi<T, R>({required Future<T> Function() call, R Function(T)? transform, required R defaultValue}) async {
  try {
    final result = await call();
    // print('Phungtd - requestApi - result type: ${result.runtimeType}');
    if (transform != null) {
      return transform(result);
    }
    
    return result as R;
  } catch (e) {
    print('Phungtd: requestApi -> Call ${call.toString()}  failed - ${e.toString()}');
    return defaultValue;
  }
}