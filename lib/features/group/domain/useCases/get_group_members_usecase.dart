import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/group_member_entity.dart';
import '../repositories/group_member_repository.dart';

@injectable
class GetGroupMembersUseCase {
  final GroupMemberRepository repository;

  GetGroupMembersUseCase(this.repository);

  Future<Either<Failure, List<GroupMember>>> call(int groupId) async {
    try {
      final result = await repository.getMembersByGroupId(groupId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
