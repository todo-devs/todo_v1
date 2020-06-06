class NautaPreLoginException implements Exception {
  final String message;

  NautaPreLoginException(this.message);
}

class NautaLoginException implements Exception {
  final String message;

  NautaLoginException(this.message);
}

class NautaLogoutException implements Exception {
  final String message;

  NautaLogoutException(this.message);
}