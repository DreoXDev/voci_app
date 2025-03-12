// core/errors/firestore_errors.dart

import 'package:voci_app/core/errors/core_errors.dart';

/// Base class for all Firestore-related errors.
class FirestoreError extends CoreError {
  /// Constructor for FirestoreError.
  FirestoreError({required super.message});
}

/// Error thrown when a document is not found.
class DocumentNotFoundError extends FirestoreError {
  final String documentId;

  /// Constructor for DocumentNotFoundError.
  DocumentNotFoundError({required this.documentId})
      : super(message: 'Document with ID $documentId not found');
}

/// Error thrown when attempting to perform an operation that the user is not allowed to do.
class PermissionDeniedError extends FirestoreError {
  /// Constructor for PermissionDeniedError.
  PermissionDeniedError({super.message = 'Permission denied'});
}

/// Error thrown when the operation to be performed is not implemented.
class NotImplementedError extends FirestoreError {
  /// Constructor for NotImplementedError.
  NotImplementedError({super.message = 'Operation not implemented'});
}