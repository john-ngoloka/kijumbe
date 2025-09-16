import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/entities/group_member_entity.dart';
import '../../domain/useCases/create_group_usecase.dart';
import '../../domain/useCases/get_groups_by_admin_usecase.dart';
import '../../domain/useCases/get_user_groups_usecase.dart';
import '../../domain/useCases/search_groups_usecase.dart';
import '../../domain/useCases/join_group_by_code_usecase.dart';
import '../../domain/useCases/add_member_to_group_usecase.dart';
import '../../domain/useCases/get_group_members_usecase.dart';

part 'group_state.dart';

@injectable
class GroupCubit extends Cubit<GroupState> {
  final CreateGroupUseCase _createGroupUseCase;
  final GetGroupsByAdminUseCase _getGroupsByAdminUseCase;
  final GetUserGroupsUseCase _getUserGroupsUseCase;
  final SearchGroupsUseCase _searchGroupsUseCase;
  final JoinGroupByCodeUseCase _joinGroupByCodeUseCase;
  final AddMemberToGroupUseCase _addMemberToGroupUseCase;
  final GetGroupMembersUseCase _getGroupMembersUseCase;

  GroupCubit(
    this._createGroupUseCase,
    this._getGroupsByAdminUseCase,
    this._getUserGroupsUseCase,
    this._searchGroupsUseCase,
    this._joinGroupByCodeUseCase,
    this._addMemberToGroupUseCase,
    this._getGroupMembersUseCase,
  ) : super(const GroupInitial());

  Future<void> createGroup({
    required String name,
    required String description,
    required int adminId,
  }) async {
    emit(const GroupLoading());

    try {
      // Generate a unique group ID
      final groupId = DateTime.now().millisecondsSinceEpoch.toString();

      final result = await _createGroupUseCase(
        CreateGroupParams(
          id: groupId,
          name: name,
          description: description,
          adminId: adminId,
          contributionAmount: 1000.0, // Default amount
          frequency: 'monthly', // Default frequency
        ),
      );

      result.fold((failure) => emit(GroupError(failure.message)), (
        group,
      ) async {
        // Add the admin as a member of the group
        await _addAdminAsMember(group.id, adminId);
        emit(GroupCreated(group: group));
      });
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> getUserGroups(int userId) async {
    emit(const GroupLoading());

    final result = await _getUserGroupsUseCase(userId);

    result.fold(
      (failure) => emit(GroupError(failure.message)),
      (groups) => emit(GroupsLoaded(groups: groups)),
    );
  }

  Future<void> getAdminGroups(int adminId) async {
    emit(const GroupLoading());

    final result = await _getGroupsByAdminUseCase(adminId);

    result.fold(
      (failure) => emit(GroupError(failure.message)),
      (groups) => emit(AdminGroupsLoaded(groups: groups)),
    );
  }

  Future<void> searchGroups(String query) async {
    if (query.trim().isEmpty) {
      emit(const GroupInitial());
      return;
    }

    emit(const GroupLoading());

    final result = await _searchGroupsUseCase(query);

    result.fold(
      (failure) => emit(GroupError(failure.message)),
      (groups) => emit(GroupsSearchResults(groups: groups)),
    );
  }

  Future<void> joinGroupByCode({
    required String groupCode,
    required int userId,
  }) async {
    print(
      '🔗 GROUP CUBIT: joinGroupByCode called with code: $groupCode, userId: $userId',
    );
    emit(const GroupLoading());

    final result = await _joinGroupByCodeUseCase(
      groupCode: groupCode,
      userId: userId,
    );

    result.fold(
      (failure) {
        print('🔗 GROUP CUBIT: joinGroupByCode failed - ${failure.message}');
        emit(GroupError(failure.message));
      },
      (group) async {
        print(
          '🔗 GROUP CUBIT: joinGroupByCode found group - ${group.name} (ID: ${group.id})',
        );
        // Add user as member to the group
        await _addMemberToGroup(group.id, userId);
        emit(GroupJoined(group: group));
      },
    );
  }

  Future<void> joinGroupById({
    required String groupId,
    required int userId,
  }) async {
    print(
      '🔗 GROUP CUBIT: joinGroupById called with groupId: $groupId, userId: $userId',
    );
    emit(const GroupLoading());

    try {
      // Add user as member to the group
      print('🔗 GROUP CUBIT: Adding member to group...');
      await _addMemberToGroup(groupId, userId);

      // Get the group details
      print('🔗 GROUP CUBIT: Getting user groups to find joined group...');
      final groups = await _getUserGroupsUseCase(userId);
      groups.fold(
        (failure) {
          print(
            '🔗 GROUP CUBIT: Failed to get user groups - ${failure.message}',
          );
          emit(GroupError(failure.message));
        },
        (userGroups) {
          print('🔗 GROUP CUBIT: Found ${userGroups.length} user groups');
          try {
            final joinedGroup = userGroups.firstWhere(
              (group) => group.id == groupId,
              orElse: () => throw Exception('Group not found'),
            );
            print(
              '🔗 GROUP CUBIT: Found joined group - ${joinedGroup.name} (ID: ${joinedGroup.id})',
            );
            emit(GroupJoined(group: joinedGroup));
          } catch (e) {
            print('🔗 GROUP CUBIT: Group not found in user groups - $e');
            emit(GroupError('Group not found'));
          }
        },
      );
    } catch (e) {
      print('🔗 GROUP CUBIT: joinGroupById error - $e');
      emit(GroupError(e.toString()));
    }
  }

  Future<void> getGroupMembers(String groupId) async {
    emit(const GroupLoading());

    final result = await _getGroupMembersUseCase(int.tryParse(groupId) ?? 0);

    result.fold(
      (failure) => emit(GroupError(failure.message)),
      (members) => emit(GroupMembersLoaded(members: members)),
    );
  }

  Future<void> _addAdminAsMember(String groupId, int adminId) async {
    final result = await _addMemberToGroupUseCase(
      AddMemberParams(
        id: DateTime.now().millisecondsSinceEpoch,
        groupId: int.tryParse(groupId) ?? DateTime.now().millisecondsSinceEpoch,
        userId: adminId,
        payoutOrder: 1, // Admin gets first payout order
      ),
    );

    result.fold(
      (failure) => emit(GroupError(failure.message)),
      (_) => {}, // Success - admin added as member
    );
  }

  Future<void> _addMemberToGroup(String groupId, int userId) async {
    final parsedGroupId =
        int.tryParse(groupId) ?? DateTime.now().millisecondsSinceEpoch;
    print(
      '🔗 GROUP CUBIT: _addMemberToGroup called with groupId: $groupId (parsed: $parsedGroupId), userId: $userId',
    );

    final result = await _addMemberToGroupUseCase(
      AddMemberParams(
        id: DateTime.now().millisecondsSinceEpoch,
        groupId: parsedGroupId,
        userId: userId,
      ),
    );

    result.fold(
      (failure) {
        print('🔗 GROUP CUBIT: _addMemberToGroup failed - ${failure.message}');
        emit(GroupError(failure.message));
      },
      (member) {
        print(
          '🔗 GROUP CUBIT: _addMemberToGroup success - member added with ID: ${member.id}',
        );
      }, // Success - member added
    );
  }

  void clearState() {
    emit(const GroupInitial());
  }
}
