part of 'group_member_cubit.dart';

abstract class GroupMemberState extends Equatable {
  const GroupMemberState();

  @override
  List<Object?> get props => [];
}

class GroupMemberInitial extends GroupMemberState {
  const GroupMemberInitial();
}

class GroupMemberLoading extends GroupMemberState {
  const GroupMemberLoading();
}

class GroupMemberAdded extends GroupMemberState {
  final GroupMember member;

  const GroupMemberAdded({required this.member});

  @override
  List<Object?> get props => [member];
}

class GroupMemberRemoved extends GroupMemberState {
  const GroupMemberRemoved();
}

class GroupMembersLoaded extends GroupMemberState {
  final List<GroupMember> members;

  const GroupMembersLoaded({required this.members});

  @override
  List<Object?> get props => [members];
}

class GroupMemberError extends GroupMemberState {
  final String message;

  const GroupMemberError(this.message);

  @override
  List<Object?> get props => [message];
}
