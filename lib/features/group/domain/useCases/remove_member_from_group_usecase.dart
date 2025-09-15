import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/group_member_repository.dart';

class RemoveMemberFromGroupUseCase {
  final GroupMemberRepository repository;

  RemoveMemberFromGroupUseCase(this.repository);

  Future<Either<Failure, void>> call(int memberId) async {
    try {
      await repository.removeMemberFromGroup(memberId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
