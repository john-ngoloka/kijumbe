import 'package:isar/isar.dart';
import '../../../models/group_model.dart';

part 'group_collection.g.dart';

@collection
class Group {
  Id id = Isar.autoIncrement;
  late String name;
  late String description;
  late int adminId; // User.id (admin)
  late double contributionAmount; // fixed per cycle
  late String frequency; // weekly, monthly, etc
  late DateTime createdAt;

  Group();

  Group.fromGroupModel(GroupModel group) {
    id = int.tryParse(group.id) ?? Isar.autoIncrement;
    name = group.name;
    description = group.description;
    adminId = group.adminId;
    contributionAmount = group.contributionAmount;
    frequency = group.frequency;
    createdAt = group.createdAt;
  }

  GroupModel toGroupModel() {
    return GroupModel(
      id: id.toString(),
      name: name,
      description: description,
      adminId: adminId,
      contributionAmount: contributionAmount,
      frequency: frequency,
      createdAt: createdAt,
    );
  }
}
