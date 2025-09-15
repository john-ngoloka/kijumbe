import '../entities/payout_entity.dart';

abstract class PayoutRepository {
  Future<Payout> recordPayout(Payout payout);
  Future<Payout> updatePayout(Payout payout);
  Future<void> deletePayout(int payoutId);
  Future<Payout?> getPayoutById(int payoutId);
  Future<List<Payout>> getPayoutsByGroupId(int groupId);
  Future<List<Payout>> getPayoutsByMemberId(int memberId);
  Future<List<Payout>> getPayoutsByCycle(int groupId, int cycleNumber);
  Future<double> getTotalPayoutsByGroup(int groupId);
  Future<double> getTotalPayoutsByMember(int memberId);
}
