import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/group_member_repository.dart';

class SetPayoutOrderUseCase {
  final GroupMemberRepository repository;

  SetPayoutOrderUseCase(this.repository);

  Future<Either<Failure, void>> call(SetPayoutOrderParams params) async {
    try {
      await repository.setPayoutOrder(params.memberId, params.payoutOrder);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class SetPayoutOrderParams {
  final int memberId;
  final int payoutOrder;

  SetPayoutOrderParams({required this.memberId, required this.payoutOrder});
}
