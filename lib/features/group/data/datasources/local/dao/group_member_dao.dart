import 'package:isar/isar.dart';
import '../../../../../../core/database/app_database.dart';
import '../../../../../../core/errors/exceptions.dart';
import '../../../models/group_member_model.dart';
import '../collection/group_member_collection.dart';

class GroupMemberDAO {
  Future<Isar> get _isar async => await AppDatabase.instance;

  /// Add a member to a group
  Future<GroupMemberModel> addMemberToGroup(
    GroupMemberModel groupMemberModel,
  ) async {
    try {
      final isar = await _isar;
      final groupMemberCollection = GroupMemberCollection.fromModel(
        groupMemberModel,
      );

      await isar.writeTxn(() async {
        await isar.groupMemberCollections.put(groupMemberCollection);
      });

      return groupMemberCollection.toModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to add member to group: ${e.toString()}',
      );
    }
  }

  /// Remove a member from a group
  Future<void> removeMemberFromGroup(int memberId) async {
    try {
      final isar = await _isar;

      await isar.writeTxn(() async {
        await isar.groupMemberCollections
            .filter()
            .idEqualTo(memberId)
            .deleteAll();
      });
    } catch (e) {
      throw CacheException(
        message: 'Failed to remove member from group: ${e.toString()}',
      );
    }
  }

  /// Update a group member
  Future<GroupMemberModel> updateMember(
    GroupMemberModel groupMemberModel,
  ) async {
    try {
      final isar = await _isar;
      final groupMemberCollection = GroupMemberCollection.fromModel(
        groupMemberModel,
      );

      await isar.writeTxn(() async {
        await isar.groupMemberCollections.put(groupMemberCollection);
      });

      return groupMemberCollection.toModel();
    } catch (e) {
      throw CacheException(message: 'Failed to update member: ${e.toString()}');
    }
  }

  /// Get a member by ID
  Future<GroupMemberModel?> getMemberById(int memberId) async {
    try {
      final isar = await _isar;
      final groupMemberCollection = await isar.groupMemberCollections
          .filter()
          .idEqualTo(memberId)
          .findFirst();

      return groupMemberCollection?.toModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get member by ID: ${e.toString()}',
      );
    }
  }

  /// Get all members of a group
  Future<List<GroupMemberModel>> getMembersByGroupId(int groupId) async {
    try {
      final isar = await _isar;
      final groupMemberCollections = await isar.groupMemberCollections
          .filter()
          .groupIdEqualTo(groupId)
          .findAll();

      return groupMemberCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get members by group ID: ${e.toString()}',
      );
    }
  }

  /// Get all groups a user is member of
  Future<List<GroupMemberModel>> getMembersByUserId(int userId) async {
    try {
      final isar = await _isar;
      final groupMemberCollections = await isar.groupMemberCollections
          .filter()
          .userIdEqualTo(userId)
          .findAll();

      return groupMemberCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get members by user ID: ${e.toString()}',
      );
    }
  }

  /// Set payout order for a member
  Future<void> setPayoutOrder(int memberId, int payoutOrder) async {
    try {
      final isar = await _isar;

      await isar.writeTxn(() async {
        final member = await isar.groupMemberCollections
            .filter()
            .idEqualTo(memberId)
            .findFirst();

        if (member != null) {
          member.payoutOrder = payoutOrder;
          await isar.groupMemberCollections.put(member);
        }
      });
    } catch (e) {
      throw CacheException(
        message: 'Failed to set payout order: ${e.toString()}',
      );
    }
  }

  /// Get members ordered by payout order
  Future<List<GroupMemberModel>> getMembersByPayoutOrder(int groupId) async {
    try {
      final isar = await _isar;
      final groupMemberCollections = await isar.groupMemberCollections
          .filter()
          .groupIdEqualTo(groupId)
          .sortByPayoutOrder()
          .findAll();

      return groupMemberCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get members by payout order: ${e.toString()}',
      );
    }
  }

  /// Get active members of a group
  Future<List<GroupMemberModel>> getActiveMembersByGroupId(int groupId) async {
    try {
      final isar = await _isar;
      final groupMemberCollections = await isar.groupMemberCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .isActiveEqualTo(true)
          .findAll();

      return groupMemberCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get active members: ${e.toString()}',
      );
    }
  }

  /// Check if user is member of group
  Future<bool> isUserMemberOfGroup(int userId, int groupId) async {
    try {
      final isar = await _isar;
      final count = await isar.groupMemberCollections
          .filter()
          .userIdEqualTo(userId)
          .and()
          .groupIdEqualTo(groupId)
          .and()
          .isActiveEqualTo(true)
          .count();

      return count > 0;
    } catch (e) {
      throw CacheException(
        message: 'Failed to check membership: ${e.toString()}',
      );
    }
  }

  /// Get member count for a group
  Future<int> getMemberCountByGroupId(int groupId) async {
    try {
      final isar = await _isar;
      return await isar.groupMemberCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .isActiveEqualTo(true)
          .count();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get member count: ${e.toString()}',
      );
    }
  }

  /// Deactivate a member (soft delete)
  Future<void> deactivateMember(int memberId) async {
    try {
      final isar = await _isar;

      await isar.writeTxn(() async {
        final member = await isar.groupMemberCollections
            .filter()
            .idEqualTo(memberId)
            .findFirst();

        if (member != null) {
          member.isActive = false;
          await isar.groupMemberCollections.put(member);
        }
      });
    } catch (e) {
      throw CacheException(
        message: 'Failed to deactivate member: ${e.toString()}',
      );
    }
  }
}
