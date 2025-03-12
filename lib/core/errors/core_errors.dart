// core/errors/core_errors.dart

/// Abstract base class for all core-related errors in the application.
abstract class CoreError implements Exception {
  final String message;

  /// Constructor for CoreError.
  CoreError({required this.message});

  @override
  String toString() => message;
}

/// Error that should be thrown when an unexpected situation occurs.
class UnexpectedError extends CoreError {
  /// Constructor for UnexpectedError.
  UnexpectedError({super.message = 'An unexpected error has occurred.'});
}

/// Error thrown when a required field is missing or null.
class MissingFieldError extends CoreError {
  final String fieldName;

  /// Constructor for MissingFieldError.
  MissingFieldError({required this.fieldName})
      : super(message: 'Missing required field: $fieldName');
}

/// Error thrown when there is an issue with the network.
class NoConnectionError extends CoreError {
  /// Constructor for NoConnectionError.
  NoConnectionError({super.message = 'No internet connection'});
}