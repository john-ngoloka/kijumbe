import 'package:injectable/injectable.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../domain/entities/group_member_entity.dart';
import '../../domain/repositories/group_member_repository.dart';
import '../datasources/local/dao/group_member_dao.dart';
import '../models/group_member_model.dart';

@LazySingleton(as: GroupMemberRepository)
class GroupMemberRepositoryImpl extends BaseRepository
    implements GroupMemberRepository {
  final GroupMemberDAO _groupMemberDAO;

  GroupMemberRepositoryImpl(this._groupMemberDAO);

  @override
  Future<GroupMember> addMemberToGroup(GroupMember groupMember) async {
    final result = await handleException(
      () async {
        final groupMemberModel = GroupMemberModel.fromEntity(groupMember);
        final addedModel = await _groupMemberDAO.addMemberToGroup(
          groupMemberModel,
        );
        return addedModel.toEntity();
      },
      operationName: 'add member to group',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (groupMember) => groupMember,
    );
  }

  @override
  Future<void> removeMemberFromGroup(int memberId) async {
    final result = await handleVoidException(
      () => _groupMemberDAO.removeMemberFromGroup(memberId),
      operationName: 'remove member from group',
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => null,
    );
  }

  @override
  Future<GroupMember> updateMember(GroupMember groupMember) async {
    final result = await handleException(
      () async {
        final groupMemberModel = GroupMemberModel.fromEntity(groupMember);
        final updatedModel = await _groupMemberDAO.updateMember(
          groupMemberModel,
        );
        return updatedModel.toEntity();
      },
      operationName: 'update member',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (groupMember) => groupMember,
    );
  }

  @override
  Future<GroupMember?> getMemberById(int memberId) async {
    final result = await handleException(
      () async {
        final groupMemberModel = await _groupMemberDAO.getMemberById(memberId);
        return groupMemberModel?.toEntity();
      },
      operationName: 'get member by ID',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (groupMember) => groupMember,
    );
  }

  @override
  Future<List<GroupMember>> getMembersByGroupId(int groupId) async {
    final result = await handleException(
      () async {
        final groupMemberModels = await _groupMemberDAO.getMembersByGroupId(
          groupId,
        );
        return groupMemberModels.map((model) => model.toEntity()).toList();
      },
      operationName: 'get members by group ID',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (members) => members,
    );
  }

  @override
  Future<List<GroupMember>> getMembersByUserId(int userId) async {
    final result = await handleException(
      () async {
        final groupMemberModels = await _groupMemberDAO.getMembersByUserId(
          userId,
        );
        return groupMemberModels.map((model) => model.toEntity()).toList();
      },
      operationName: 'get members by user ID',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (members) => members,
    );
  }

  @override
  Future<void> setPayoutOrder(int memberId, int payoutOrder) async {
    final result = await handleVoidException(
      () => _groupMemberDAO.setPayoutOrder(memberId, payoutOrder),
      operationName: 'set payout order',
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => null,
    );
  }

  @override
  Future<List<GroupMember>> getMembersByPayoutOrder(int groupId) async {
    final result = await handleException(
      () async {
        final groupMemberModels = await _groupMemberDAO.getMembersByPayoutOrder(
          groupId,
        );
        return groupMemberModels.map((model) => model.toEntity()).toList();
      },
      operationName: 'get members by payout order',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (members) => members,
    );
  }
}
