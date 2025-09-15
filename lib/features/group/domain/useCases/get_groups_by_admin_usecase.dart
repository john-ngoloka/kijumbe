import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

class GetGroupsByAdminUseCase {
  final GroupRepository repository;

  GetGroupsByAdminUseCase(this.repository);

  Future<Either<Failure, List<Group>>> call(int adminId) async {
    try {
      final result = await repository.getGroupsByAdminId(adminId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
