import 'package:equatable/equatable.dart';

class Error extends Equatable {
  final String message;
  final String? stackTrace;

  const Error({required this.message, this.stackTrace});

  @override
  List<Object?> get props => [message, stackTrace];
}

class DatabaseError extends Error {
  const DatabaseError({required super.message, super.stackTrace});
}

class AuthenticationError extends Error {
  const AuthenticationError({required super.message, super.stackTrace});
}

class UnknownError extends Error {
  const UnknownError({required super.message, super.stackTrace});
}
