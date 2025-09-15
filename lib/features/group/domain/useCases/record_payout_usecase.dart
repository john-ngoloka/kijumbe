import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payout_entity.dart';
import '../repositories/payout_repository.dart';

class RecordPayoutUseCase {
  final PayoutRepository repository;

  RecordPayoutUseCase(this.repository);

  Future<Either<Failure, Payout>> call(RecordPayoutParams params) async {
    try {
      final payout = Payout(
        id: params.id,
        groupId: params.groupId,
        memberId: params.memberId,
        amount: params.amount,
        date: DateTime.now(),
        cycleNumber: params.cycleNumber,
      );

      final result = await repository.recordPayout(payout);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class RecordPayoutParams {
  final int id;
  final int groupId;
  final int memberId;
  final double amount;
  final int cycleNumber;

  RecordPayoutParams({
    required this.id,
    required this.groupId,
    required this.memberId,
    required this.amount,
    required this.cycleNumber,
  });
}
