import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/group_entity.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

@freezed
class GroupModel with _$GroupModel {
  const factory GroupModel({
    required String id,
    required String name,
    required String description,
    required int adminId,
    required double contributionAmount,
    required String frequency,
    required DateTime createdAt,
  }) = _GroupModel;

  const GroupModel._();

  factory GroupModel.fromJson(Map<String, dynamic> json) => _$GroupModelFromJson(json);

  Group toEntity() {
    return Group(
      id: id,
      name: name,
      description: description,
      adminId: adminId,
      contributionAmount: contributionAmount,
      frequency: frequency,
      createdAt: createdAt,
    );
  }

  factory GroupModel.fromEntity(Group group) {
    return GroupModel(
      id: group.id,
      name: group.name,
      description: group.description,
      adminId: group.adminId,
      contributionAmount: group.contributionAmount,
      frequency: group.frequency,
      createdAt: group.createdAt,
    );
  }
}