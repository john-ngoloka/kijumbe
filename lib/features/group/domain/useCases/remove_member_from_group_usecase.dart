import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/group_member_repository.dart';

@injectable
class RemoveMemberFromGroupUseCase {
  final GroupMemberRepository repository;

  RemoveMemberFromGroupUseCase(this.repository);

  Future<Either<Failure, void>> call(RemoveMemberParams params) async {
    try {
      await repository.removeMemberFromGroup(params.groupId, params.userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class RemoveMemberParams {
  final int groupId;
  final int userId;

  RemoveMemberParams({required this.groupId, required this.userId});
}
