import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/group_member_entity.dart';
import '../repositories/group_member_repository.dart';

@injectable
class AddMemberToGroupUseCase {
  final GroupMemberRepository repository;

  AddMemberToGroupUseCase(this.repository);

  Future<Either<Failure, GroupMember>> call(AddMemberParams params) async {
    try {
      final groupMember = GroupMember(
        id: params.id,
        groupId: params.groupId,
        userId: params.userId,
        isActive: true,
        payoutOrder: params.payoutOrder,
        joinedAt: DateTime.now(),
      );

      final result = await repository.addMemberToGroup(groupMember);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class AddMemberParams {
  final int id;
  final int groupId;
  final int userId;
  final int? payoutOrder;

  AddMemberParams({
    required this.id,
    required this.groupId,
    required this.userId,
    this.payoutOrder,
  });
}
