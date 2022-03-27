///Represents the different login exceptions which can occur
class UserNotFoundException implements Exception {}

class WrongPasswordException implements Exception {}

///Register
class WeakPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class InvalidEmailException implements Exception {}

class GenericAuthException implements Exception {}

class UserNotLoggedInException implements Exception {}
