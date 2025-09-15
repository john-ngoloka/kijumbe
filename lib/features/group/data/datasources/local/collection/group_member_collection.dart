import 'package:isar/isar.dart';
import '../../../models/group_member_model.dart';

part 'group_member_collection.g.dart';

@collection
class GroupMemberCollection {
  Id id = Isar.autoIncrement;

  @Index()
  late int groupId; // Group.id

  @Index()
  late int userId; // User.id

  late bool isActive;

  int? payoutOrder; // order in the cycle

  late DateTime joinedAt;

  GroupMemberCollection();

  GroupMemberModel toModel() {
    return GroupMemberModel(
      id: id,
      groupId: groupId,
      userId: userId,
      isActive: isActive,
      payoutOrder: payoutOrder,
      joinedAt: joinedAt,
    );
  }

  factory GroupMemberCollection.fromModel(GroupMemberModel model) {
    final collection = GroupMemberCollection();
    collection.id = model.id;
    collection.groupId = model.groupId;
    collection.userId = model.userId;
    collection.isActive = model.isActive;
    collection.payoutOrder = model.payoutOrder;
    collection.joinedAt = model.joinedAt;
    return collection;
  }
}
