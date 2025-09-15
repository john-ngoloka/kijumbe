import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/group_member_entity.dart';
import '../repositories/group_member_repository.dart';

class GetMembersByPayoutOrderUseCase {
  final GroupMemberRepository repository;

  GetMembersByPayoutOrderUseCase(this.repository);

  Future<Either<Failure, List<GroupMember>>> call(int groupId) async {
    try {
      final result = await repository.getMembersByPayoutOrder(groupId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
