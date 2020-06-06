class NautaPreLoginException implements Exception {
  final String message;

  NautaPreLoginException(this.message);
}

class NautaLoginException implements Exception {
  final String message;

  NautaLoginException(this.message);
}