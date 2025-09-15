import 'package:equatable/equatable.dart';

class GroupMember extends Equatable {
  final int id;
  final int groupId; // Group.id
  final int userId; // User.id
  final bool isActive;
  final int? payoutOrder; // order in the cycle
  final DateTime joinedAt;

  const GroupMember({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.isActive,
    this.payoutOrder,
    required this.joinedAt,
  });

  @override
  List<Object?> get props => [
    id,
    groupId,
    userId,
    isActive,
    payoutOrder,
    joinedAt,
  ];
}
