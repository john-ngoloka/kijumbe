import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cycle_entity.dart';
import '../repositories/cycle_repository.dart';

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
        isActive: true,
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

  StartNewCycleParams({
    required this.id,
    required this.groupId,
    required this.cycleNumber,
  });
}
