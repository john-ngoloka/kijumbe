import 'package:injectable/injectable.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/repositories/group_repository.dart';
import '../datasources/local/dao/group_dao.dart';
import '../models/group_model.dart';

@LazySingleton(as: GroupRepository)
class GroupRepositoryImpl extends BaseRepository implements GroupRepository {
  final GroupDAO _groupDAO;

  GroupRepositoryImpl(this._groupDAO);

  @override
  Future<Group> createGroup(Group group) async {
    final result = await handleException(
      () async {
        final groupModel = GroupModel.fromEntity(group);
        final createdModel = await _groupDAO.createGroup(groupModel);
        return createdModel.toEntity();
      },
      operationName: 'create group',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (group) => group,
    );
  }

  @override
  Future<Group> updateGroup(Group group) async {
    final result = await handleException(
      () async {
        final groupModel = GroupModel.fromEntity(group);
        final updatedModel = await _groupDAO.updateGroup(groupModel);
        return updatedModel.toEntity();
      },
      operationName: 'update group',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (group) => group,
    );
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    final result = await handleVoidException(
      () => _groupDAO.deleteGroup(groupId),
      operationName: 'delete group',
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => null,
    );
  }

  @override
  Future<Group?> getGroupById(String groupId) async {
    final result = await handleException(
      () async {
        final groupModel = await _groupDAO.getGroupById(groupId);
        return groupModel?.toEntity();
      },
      operationName: 'get group by ID',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (group) => group,
    );
  }

  @override
  Future<List<Group>> getGroupsByAdminId(int adminId) async {
    final result = await handleException(
      () async {
        final groupModels = await _groupDAO.getGroupsByAdminId(adminId);
        return groupModels.map((model) => model.toEntity()).toList();
      },
      operationName: 'get groups by admin ID',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (groups) => groups,
    );
  }

  @override
  Future<List<Group>> getAllGroups() async {
    final result = await handleException(
      () async {
        final groupModels = await _groupDAO.getAllGroups();
        return groupModels.map((model) => model.toEntity()).toList();
      },
      operationName: 'get all groups',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (groups) => groups,
    );
  }
}
