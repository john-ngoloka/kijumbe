import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

class UpdateGroupUseCase {
  final GroupRepository repository;

  UpdateGroupUseCase(this.repository);

  Future<Either<Failure, Group>> call(Group group) async {
    try {
      final result = await repository.updateGroup(group);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
