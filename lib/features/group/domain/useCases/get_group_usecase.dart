import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

class GetGroupUseCase {
  final GroupRepository repository;

  GetGroupUseCase(this.repository);

  Future<Either<Failure, Group?>> call(String groupId) async {
    try {
      final result = await repository.getGroupById(groupId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
