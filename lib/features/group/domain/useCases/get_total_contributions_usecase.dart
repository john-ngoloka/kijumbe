import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/contribution_repository.dart';

class GetTotalContributionsUseCase {
  final ContributionRepository repository;

  GetTotalContributionsUseCase(this.repository);

  Future<Either<Failure, double>> call(
    GetTotalContributionsParams params,
  ) async {
    try {
      double total;
      if (params.memberId != null) {
        total = await repository.getTotalContributionsByMember(
          params.memberId!,
        );
      } else {
        total = await repository.getTotalContributionsByGroup(params.groupId);
      }
      return Right(total);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class GetTotalContributionsParams {
  final int groupId;
  final int? memberId;

  GetTotalContributionsParams({required this.groupId, this.memberId});
}
