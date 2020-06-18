class NautaException implements Exception {
  final message;

  NautaException(this.message);
}

class NautaPreLoginException extends NautaException {
  NautaPreLoginException(message) : super(message);
}

class NautaLoginException extends NautaException {
  NautaLoginException(message) : super(message);
}

class NautaLogoutException extends NautaException {
  NautaLogoutException(message) : super(message);
}

class NautaTimeException extends NautaException {
  NautaTimeException(message) : super(message);
}
