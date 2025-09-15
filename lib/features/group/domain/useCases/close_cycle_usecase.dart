import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cycle_entity.dart';
import '../repositories/cycle_repository.dart';

class CloseCycleUseCase {
  final CycleRepository repository;

  CloseCycleUseCase(this.repository);

  Future<Either<Failure, Cycle>> call(int cycleId) async {
    try {
      final result = await repository.closeCycle(cycleId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
