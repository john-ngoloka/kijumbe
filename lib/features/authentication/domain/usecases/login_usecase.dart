import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Result<AuthTokens>> call({
    required String phone,
    required String password,
  }) async {
    if (phone.isEmpty || password.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Phone and password are required'),
      );
    }

    return await _repository.login(phone: phone, password: password);
  }
}
