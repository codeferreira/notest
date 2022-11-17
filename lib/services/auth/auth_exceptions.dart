// Login Exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// Register Exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic excepctions

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
