import '../entities/contribution_entity.dart';

abstract class ContributionRepository {
  Future<Contribution> recordContribution(Contribution contribution);
  Future<Contribution> updateContribution(Contribution contribution);
  Future<void> deleteContribution(int contributionId);
  Future<Contribution?> getContributionById(int contributionId);
  Future<List<Contribution>> getContributionsByGroupId(int groupId);
  Future<List<Contribution>> getContributionsByMemberId(int memberId);
  Future<List<Contribution>> getPendingContributions(int groupId);
  Future<List<Contribution>> getPaidContributions(int groupId);
  Future<double> getTotalContributionsByGroup(int groupId);
  Future<double> getTotalContributionsByMember(int memberId);
}
