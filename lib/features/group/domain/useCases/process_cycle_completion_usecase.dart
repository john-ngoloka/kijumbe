import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cycle_entity.dart';
import '../entities/payout_entity.dart';
import '../repositories/cycle_repository.dart';
import '../repositories/group_member_repository.dart';
import '../repositories/contribution_repository.dart';
import '../repositories/payout_repository.dart';

class ProcessCycleCompletionUseCase {
  final CycleRepository cycleRepository;
  final GroupMemberRepository groupMemberRepository;
  final ContributionRepository contributionRepository;
  final PayoutRepository payoutRepository;

  ProcessCycleCompletionUseCase(
    this.cycleRepository,
    this.groupMemberRepository,
    this.contributionRepository,
    this.payoutRepository,
  );

  Future<Either<Failure, CycleCompletionResult>> call(int groupId) async {
    try {
      // Get active cycle
      final activeCycle = await cycleRepository.getActiveCycleByGroupId(
        groupId,
      );
      if (activeCycle == null) {
        return Left(ServerFailure(message: "No active cycle found for this group"));
      }

      // Get all members ordered by payout order
      final members = await groupMemberRepository.getMembersByPayoutOrder(
        groupId,
      );

      // Get total contributions for this cycle
      final contributions = await contributionRepository
          .getContributionsByGroupId(groupId);
      final totalContributions = contributions.fold(
        0.0,
        (sum, c) => sum + c.amount,
      );

      // Calculate payout per member
      final payoutPerMember = totalContributions / members.length;

      // Record payouts for each member
      final payouts = <Payout>[];
      for (final member in members) {
        final payout = Payout(
          id: DateTime.now().millisecondsSinceEpoch + member.id,
          groupId: groupId,
          memberId: member.id,
          amount: payoutPerMember,
          date: DateTime.now(),
          cycleNumber: activeCycle.cycleNumber,
        );

        final recordedPayout = await payoutRepository.recordPayout(payout);
        payouts.add(recordedPayout);
      }

      // Close the cycle
      final closedCycle = await cycleRepository.closeCycle(activeCycle.id);

      return Right(
        CycleCompletionResult(
          cycle: closedCycle,
          payouts: payouts,
          totalPayoutAmount: totalContributions,
          membersPaid: members.length,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class CycleCompletionResult {
  final Cycle cycle;
  final List<Payout> payouts;
  final double totalPayoutAmount;
  final int membersPaid;

  CycleCompletionResult({
    required this.cycle,
    required this.payouts,
    required this.totalPayoutAmount,
    required this.membersPaid,
  });
}
