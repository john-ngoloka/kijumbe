import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignupUseCase {
  final AuthRepository _authRepository;

  SignupUseCase(this._authRepository);

  Future<Either<Failure, AuthTokens>> call({
    required String phone,
    required String password,
    required String name,
  }) async {
    return await _authRepository.signup(
      phone: phone,
      password: password,
      name: name,
    );
  }
}
