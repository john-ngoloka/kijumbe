import '../entities/group_entity.dart';

abstract class GroupRepository {
  Future<Group> createGroup(Group group);
  Future<Group> updateGroup(Group group);
  Future<void> deleteGroup(String groupId);
  Future<Group?> getGroupById(String groupId);
  Future<List<Group>> getGroupsByAdminId(int adminId);
  Future<List<Group>> getGroupsByUserId(int userId);
  Future<List<Group>> searchGroups(String query);
  Future<Group> joinGroupByCode(String groupCode, int userId);
  Future<List<Group>> getAllGroups();
}
