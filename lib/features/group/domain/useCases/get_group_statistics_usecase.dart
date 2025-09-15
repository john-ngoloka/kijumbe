import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/contribution_repository.dart';
import '../repositories/payout_repository.dart';
import '../repositories/cycle_repository.dart';
import '../repositories/group_member_repository.dart';

class GetGroupStatisticsUseCase {
  final ContributionRepository contributionRepository;
  final PayoutRepository payoutRepository;
  final CycleRepository cycleRepository;
  final GroupMemberRepository groupMemberRepository;

  GetGroupStatisticsUseCase(
    this.contributionRepository,
    this.payoutRepository,
    this.cycleRepository,
    this.groupMemberRepository,
  );

  Future<Either<Failure, GroupStatisticsData>> call(int groupId) async {
    try {
      final totalContributions = await contributionRepository
          .getTotalContributionsByGroup(groupId);
      final totalPayouts = await payoutRepository.getTotalPayoutsByGroup(
        groupId,
      );
      final completedCycles = await cycleRepository.getCompletedCyclesByGroupId(
        groupId,
      );
      final members = await groupMemberRepository.getMembersByGroupId(groupId);

      final statisticsData = GroupStatisticsData(
        groupId: groupId,
        totalContributions: totalContributions,
        totalPayouts: totalPayouts,
        completedCycles: completedCycles.length,
        activeMembers: members.where((m) => m.isActive).length,
        totalMembers: members.length,
        netBalance: totalContributions - totalPayouts,
      );

      return Right(statisticsData);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class GroupStatisticsData {
  final int groupId;
  final double totalContributions;
  final double totalPayouts;
  final int completedCycles;
  final int activeMembers;
  final int totalMembers;
  final double netBalance;

  GroupStatisticsData({
    required this.groupId,
    required this.totalContributions,
    required this.totalPayouts,
    required this.completedCycles,
    required this.activeMembers,
    required this.totalMembers,
    required this.netBalance,
  });
}
