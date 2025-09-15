import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/contribution_entity.dart';
import '../entities/payout_entity.dart';
import '../repositories/contribution_repository.dart';
import '../repositories/payout_repository.dart';

class GetGroupLedgerUseCase {
  final ContributionRepository contributionRepository;
  final PayoutRepository payoutRepository;

  GetGroupLedgerUseCase(this.contributionRepository, this.payoutRepository);

  Future<Either<Failure, GroupLedgerData>> call(int groupId) async {
    try {
      final contributions = await contributionRepository
          .getContributionsByGroupId(groupId);
      final payouts = await payoutRepository.getPayoutsByGroupId(groupId);

      final ledgerData = GroupLedgerData(
        contributions: contributions,
        payouts: payouts,
        totalContributions: contributions.fold(0.0, (sum, c) => sum + c.amount),
        totalPayouts: payouts.fold(0.0, (sum, p) => sum + p.amount),
      );

      return Right(ledgerData);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class GroupLedgerData {
  final List<Contribution> contributions;
  final List<Payout> payouts;
  final double totalContributions;
  final double totalPayouts;

  GroupLedgerData({
    required this.contributions,
    required this.payouts,
    required this.totalContributions,
    required this.totalPayouts,
  });
}
