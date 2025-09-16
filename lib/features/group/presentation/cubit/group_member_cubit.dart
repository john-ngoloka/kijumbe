import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/group_member_entity.dart';
import '../../domain/useCases/add_member_to_group_usecase.dart';
import '../../domain/useCases/get_group_members_usecase.dart';
import '../../domain/useCases/remove_member_from_group_usecase.dart';

part 'group_member_state.dart';

@injectable
class GroupMemberCubit extends Cubit<GroupMemberState> {
  final AddMemberToGroupUseCase _addMemberToGroupUseCase;
  final GetGroupMembersUseCase _getGroupMembersUseCase;
  final RemoveMemberFromGroupUseCase _removeMemberFromGroupUseCase;

  GroupMemberCubit(
    this._addMemberToGroupUseCase,
    this._getGroupMembersUseCase,
    this._removeMemberFromGroupUseCase,
  ) : super(const GroupMemberInitial());

  Future<void> addMemberToGroup({
    required int groupId,
    required int userId,
    int? payoutOrder,
  }) async {
    emit(const GroupMemberLoading());

    final result = await _addMemberToGroupUseCase(
      AddMemberParams(
        id: DateTime.now().millisecondsSinceEpoch,
        groupId: groupId,
        userId: userId,
        payoutOrder: payoutOrder,
      ),
    );

    result.fold(
      (failure) => emit(GroupMemberError(failure.message)),
      (member) => emit(GroupMemberAdded(member: member)),
    );
  }

  Future<void> getGroupMembers(int groupId) async {
    emit(const GroupMemberLoading());

    final result = await _getGroupMembersUseCase(groupId);

    result.fold(
      (failure) => emit(GroupMemberError(failure.message)),
      (members) => emit(GroupMembersLoaded(members: members)),
    );
  }

  Future<void> removeMemberFromGroup({
    required int groupId,
    required int userId,
  }) async {
    emit(const GroupMemberLoading());

    final result = await _removeMemberFromGroupUseCase(
      RemoveMemberParams(groupId: groupId, userId: userId),
    );

    result.fold(
      (failure) => emit(GroupMemberError(failure.message)),
      (_) => emit(const GroupMemberRemoved()),
    );
  }

  void clearState() {
    emit(const GroupMemberInitial());
  }
}
