import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/contribution_entity.dart';
import '../repositories/contribution_repository.dart';

@injectable
class GetContributionsByGroupUseCase {
  final ContributionRepository repository;

  GetContributionsByGroupUseCase(this.repository);

  Future<Either<Failure, List<Contribution>>> call(int groupId) async {
    try {
      final result = await repository.getContributionsByGroupId(groupId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
