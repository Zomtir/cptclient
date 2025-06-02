sealed class Result<T> {
  const Result();

  T unwrap() {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    throw Exception('Tried to unwrap a Failure');
  }
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Failure<T> extends Result<T> {
  const Failure();
}
