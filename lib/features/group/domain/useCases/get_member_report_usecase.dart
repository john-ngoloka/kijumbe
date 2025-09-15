import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/contribution_entity.dart';
import '../entities/payout_entity.dart';
import '../repositories/contribution_repository.dart';
import '../repositories/payout_repository.dart';

class GetMemberReportUseCase {
  final ContributionRepository contributionRepository;
  final PayoutRepository payoutRepository;

  GetMemberReportUseCase(this.contributionRepository, this.payoutRepository);

  Future<Either<Failure, MemberReportData>> call(int memberId) async {
    try {
      final contributions = await contributionRepository
          .getContributionsByMemberId(memberId);
      final payouts = await payoutRepository.getPayoutsByMemberId(memberId);

      final reportData = MemberReportData(
        memberId: memberId,
        contributions: contributions,
        payouts: payouts,
        totalContributions: contributions.fold(0.0, (sum, c) => sum + c.amount),
        totalPayouts: payouts.fold(0.0, (sum, p) => sum + p.amount),
        netBalance:
            contributions.fold(0.0, (sum, c) => sum + c.amount) -
            payouts.fold(0.0, (sum, p) => sum + p.amount),
      );

      return Right(reportData);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class MemberReportData {
  final int memberId;
  final List<Contribution> contributions;
  final List<Payout> payouts;
  final double totalContributions;
  final double totalPayouts;
  final double netBalance;

  MemberReportData({
    required this.memberId,
    required this.contributions,
    required this.payouts,
    required this.totalContributions,
    required this.totalPayouts,
    required this.netBalance,
  });
}
