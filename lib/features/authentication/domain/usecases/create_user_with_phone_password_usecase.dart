import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

@injectable
class CreateUserWithPhonePasswordUseCase {
  final AuthRepository _authRepository;

  CreateUserWithPhonePasswordUseCase(this._authRepository);

  Future<Either<Failure, AuthTokens>> call({
    required String phone,
    required String name,
  }) async {
    // Use phone number as the default password
    return await _authRepository.signup(
      phone: phone,
      password: phone, // Phone number becomes the password
      name: name,
    );
  }
}
