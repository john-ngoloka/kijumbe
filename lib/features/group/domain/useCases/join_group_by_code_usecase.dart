import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

@injectable
class JoinGroupByCodeUseCase {
  final GroupRepository repository;

  JoinGroupByCodeUseCase(this.repository);

  Future<Either<Failure, Group>> call({
    required String groupCode,
    required int userId,
  }) async {
    try {
      final result = await repository.joinGroupByCode(groupCode, userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
