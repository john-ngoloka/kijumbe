import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cycle_entity.dart';
import '../repositories/cycle_repository.dart';

@injectable
class GetActiveCycleUseCase {
  final CycleRepository repository;

  GetActiveCycleUseCase(this.repository);

  Future<Either<Failure, Cycle?>> call(int groupId) async {
    try {
      final result = await repository.getActiveCycleByGroupId(groupId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
