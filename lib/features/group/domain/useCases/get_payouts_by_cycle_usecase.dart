import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payout_entity.dart';
import '../repositories/payout_repository.dart';

class GetPayoutsByCycleUseCase {
  final PayoutRepository repository;

  GetPayoutsByCycleUseCase(this.repository);

  Future<Either<Failure, List<Payout>>> call(
    GetPayoutsByCycleParams params,
  ) async {
    try {
      final result = await repository.getPayoutsByCycle(
        params.groupId,
        params.cycleNumber,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class GetPayoutsByCycleParams {
  final int groupId;
  final int cycleNumber;

  GetPayoutsByCycleParams({required this.groupId, required this.cycleNumber});
}
