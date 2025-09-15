import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/group_member_entity.dart';

part 'group_member_model.freezed.dart';
part 'group_member_model.g.dart';

@freezed
class GroupMemberModel with _$GroupMemberModel {
  const factory GroupMemberModel({
    required int id,
    @JsonKey(name: 'group_id') required int groupId,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'payout_order') int? payoutOrder,
    @JsonKey(name: 'joined_at') required DateTime joinedAt,
  }) = _GroupMemberModel;

  const GroupMemberModel._();

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberModelFromJson(json);

  GroupMember toEntity() {
    return GroupMember(
      id: id,
      groupId: groupId,
      userId: userId,
      isActive: isActive,
      payoutOrder: payoutOrder,
      joinedAt: joinedAt,
    );
  }

  factory GroupMemberModel.fromEntity(GroupMember groupMember) {
    return GroupMemberModel(
      id: groupMember.id,
      groupId: groupMember.groupId,
      userId: groupMember.userId,
      isActive: groupMember.isActive,
      payoutOrder: groupMember.payoutOrder,
      joinedAt: groupMember.joinedAt,
    );
  }
}
