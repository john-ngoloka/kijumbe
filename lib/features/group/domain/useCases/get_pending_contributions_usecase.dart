import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/contribution_entity.dart';
import '../repositories/contribution_repository.dart';

class GetPendingContributionsUseCase {
  final ContributionRepository repository;

  GetPendingContributionsUseCase(this.repository);

  Future<Either<Failure, List<Contribution>>> call(int groupId) async {
    try {
      final result = await repository.getPendingContributions(groupId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
