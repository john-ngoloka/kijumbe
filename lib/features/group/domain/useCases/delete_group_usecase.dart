import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/group_repository.dart';

class DeleteGroupUseCase {
  final GroupRepository repository;

  DeleteGroupUseCase(this.repository);

  Future<Either<Failure, void>> call(String groupId) async {
    try {
      await repository.deleteGroup(groupId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
