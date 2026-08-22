class Failure {
  final String message;
  const Failure(this.message);
}

class MovieFailure extends Failure implements Exception {
  const MovieFailure(super.message);

  @override
  String toString() => message;
}
