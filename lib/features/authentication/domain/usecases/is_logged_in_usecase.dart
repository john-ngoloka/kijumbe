import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

@injectable
class IsLoggedInUseCase {
  final AuthRepository _repository;

  IsLoggedInUseCase(this._repository);

  Future<Result<bool>> call() async {
    return await _repository.isLoggedIn();
  }
}
