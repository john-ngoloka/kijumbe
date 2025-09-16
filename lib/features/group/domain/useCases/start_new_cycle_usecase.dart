import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cycle_entity.dart';
import '../repositories/cycle_repository.dart';

@injectable
class StartNewCycleUseCase {
  final CycleRepository repository;

  StartNewCycleUseCase(this.repository);

  Future<Either<Failure, Cycle>> call(StartNewCycleParams params) async {
    try {
      final cycle = Cycle(
        id: params.id,
        groupId: params.groupId,
        cycleNumber: params.cycleNumber,
        startDate: DateTime.now(),
        endDate: null,
        deadline: params.deadline,
        isActive: true,
        targetAmount: params.targetAmount,
        currentAmount: 0.0,
      );

      final result = await repository.createCycle(cycle);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class StartNewCycleParams {
  final int id;
  final int groupId;
  final int cycleNumber;
  final double targetAmount;
  final DateTime deadline;

  StartNewCycleParams({
    required this.id,
    required this.groupId,
    required this.cycleNumber,
    required this.targetAmount,
    required this.deadline,
  });
}
