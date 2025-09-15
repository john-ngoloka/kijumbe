import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/contribution_entity.dart';

part 'contribution_model.freezed.dart';
part 'contribution_model.g.dart';

@freezed
class ContributionModel with _$ContributionModel {
  const factory ContributionModel({
    required int id,
    @JsonKey(name: 'group_id') required int groupId,
    @JsonKey(name: 'member_id') required int memberId,
    required double amount,
    required DateTime date,
    @JsonKey(name: 'is_paid') required bool isPaid,
  }) = _ContributionModel;

  const ContributionModel._();

  factory ContributionModel.fromJson(Map<String, dynamic> json) =>
      _$ContributionModelFromJson(json);

  Contribution toEntity() {
    return Contribution(
      id: id,
      groupId: groupId,
      memberId: memberId,
      amount: amount,
      date: date,
      isPaid: isPaid,
    );
  }

  factory ContributionModel.fromEntity(Contribution contribution) {
    return ContributionModel(
      id: contribution.id,
      groupId: contribution.groupId,
      memberId: contribution.memberId,
      amount: contribution.amount,
      date: contribution.date,
      isPaid: contribution.isPaid,
    );
  }
}
