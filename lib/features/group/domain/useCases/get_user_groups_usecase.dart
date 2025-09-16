import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

@injectable
class GetUserGroupsUseCase {
  final GroupRepository repository;

  GetUserGroupsUseCase(this.repository);

  Future<Either<Failure, List<Group>>> call(int userId) async {
    try {
      final result = await repository.getGroupsByUserId(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
