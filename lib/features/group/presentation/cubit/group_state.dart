part of 'group_cubit.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

class GroupInitial extends GroupState {
  const GroupInitial();
}

class GroupLoading extends GroupState {
  const GroupLoading();
}

class GroupCreated extends GroupState {
  final Group group;

  const GroupCreated({required this.group});

  @override
  List<Object?> get props => [group];
}

class GroupJoined extends GroupState {
  final Group group;

  const GroupJoined({required this.group});

  @override
  List<Object?> get props => [group];
}

class GroupsLoaded extends GroupState {
  final List<Group> groups;

  const GroupsLoaded({required this.groups});

  @override
  List<Object?> get props => [groups];
}

class AdminGroupsLoaded extends GroupState {
  final List<Group> groups;

  const AdminGroupsLoaded({required this.groups});

  @override
  List<Object?> get props => [groups];
}

class GroupsSearchResults extends GroupState {
  final List<Group> groups;

  const GroupsSearchResults({required this.groups});

  @override
  List<Object?> get props => [groups];
}

class GroupMembersLoaded extends GroupState {
  final List<GroupMember> members;

  const GroupMembersLoaded({required this.members});

  @override
  List<Object?> get props => [members];
}

class GroupError extends GroupState {
  final String message;

  const GroupError(this.message);

  @override
  List<Object?> get props => [message];
}
