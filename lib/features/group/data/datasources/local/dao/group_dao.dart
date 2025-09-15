import 'package:isar/isar.dart';
import '../../../../../../core/database/app_database.dart';
import '../../../../../../core/errors/exceptions.dart';
import '../../../models/group_model.dart';
import '../collection/group_collection.dart';

class GroupDAO {
  Future<Isar> get _isar async => await AppDatabase.instance;

  /// Create a new group
  Future<GroupModel> createGroup(GroupModel groupModel) async {
    try {
      final isar = await _isar;
      final groupCollection = Group.fromGroupModel(groupModel);

      await isar.writeTxn(() async {
        await isar.groups.put(groupCollection);
      });

      return groupCollection.toGroupModel();
    } catch (e) {
      throw CacheException(message: 'Failed to create group: ${e.toString()}');
    }
  }

  /// Update an existing group
  Future<GroupModel> updateGroup(GroupModel groupModel) async {
    try {
      final isar = await _isar;
      final groupCollection = Group.fromGroupModel(groupModel);

      await isar.writeTxn(() async {
        await isar.groups.put(groupCollection);
      });

      return groupCollection.toGroupModel();
    } catch (e) {
      throw CacheException(message: 'Failed to update group: ${e.toString()}');
    }
  }

  /// Delete a group by ID
  Future<void> deleteGroup(String groupId) async {
    try {
      final isar = await _isar;

      await isar.writeTxn(() async {
        await isar.groups.filter().idEqualTo(groupId as Id).deleteAll();
      });
    } catch (e) {
      throw CacheException(message: 'Failed to delete group: ${e.toString()}');
    }
  }

  /// Get a group by ID
  Future<GroupModel?> getGroupById(String groupId) async {
    try {
      final isar = await _isar;
      final groupCollection = await isar.groups
          .filter()
          .idEqualTo(groupId as Id)
          .findFirst();

      return groupCollection?.toGroupModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get group by ID: ${e.toString()}',
      );
    }
  }

  /// Get all groups by admin ID
  Future<List<GroupModel>> getGroupsByAdminId(int adminId) async {
    try {
      final isar = await _isar;
      final groupCollections = await isar.groups
          .filter()
          .adminIdEqualTo(adminId)
          .findAll();

      return groupCollections
          .map((collection) => collection.toGroupModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get groups by admin ID: ${e.toString()}',
      );
    }
  }

  /// Get all groups
  Future<List<GroupModel>> getAllGroups() async {
    try {
      final isar = await _isar;
      final groupCollections = await isar.groups.where().findAll();

      return groupCollections
          .map((collection) => collection.toGroupModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get all groups: ${e.toString()}',
      );
    }
  }

  /// Check if group exists
  Future<bool> groupExists(String groupId) async {
    try {
      final isar = await _isar;
      final count = await isar.groups.filter().idEqualTo(groupId as Id).count();

      return count > 0;
    } catch (e) {
      throw CacheException(
        message: 'Failed to check if group exists: ${e.toString()}',
      );
    }
  }

  /// Get groups count
  Future<int> getGroupsCount() async {
    try {
      final isar = await _isar;
      return await isar.groups.count();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get groups count: ${e.toString()}',
      );
    }
  }
}
