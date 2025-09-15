import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred',
    super.statusCode,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Network error occurred',
    super.statusCode,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache error occurred',
    super.statusCode,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Validation error occurred',
    super.statusCode,
  });
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    super.message = 'Authentication failed',
    super.statusCode,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Unknown error occurred',
    super.statusCode,
  });
}
