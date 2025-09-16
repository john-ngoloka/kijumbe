import '../entities/group_member_entity.dart';

abstract class GroupMemberRepository {
  Future<GroupMember> addMemberToGroup(GroupMember groupMember);
  Future<void> removeMemberFromGroup(int groupId, int userId);
  Future<GroupMember> updateMember(GroupMember groupMember);
  Future<GroupMember?> getMemberById(int memberId);
  Future<List<GroupMember>> getMembersByGroupId(int groupId);
  Future<List<GroupMember>> getMembersByUserId(int userId);
  Future<void> setPayoutOrder(int memberId, int payoutOrder);
  Future<List<GroupMember>> getMembersByPayoutOrder(int groupId);
}
