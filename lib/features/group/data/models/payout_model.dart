import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/payout_entity.dart';

part 'payout_model.freezed.dart';
part 'payout_model.g.dart';

@freezed
class PayoutModel with _$PayoutModel {
  const factory PayoutModel({
    required int id,
    @JsonKey(name: 'group_id') required int groupId,
    @JsonKey(name: 'member_id') required int memberId,
    required double amount,
    required DateTime date,
    @JsonKey(name: 'cycle_number') required int cycleNumber,
  }) = _PayoutModel;

  const PayoutModel._();

  factory PayoutModel.fromJson(Map<String, dynamic> json) =>
      _$PayoutModelFromJson(json);

  Payout toEntity() {
    return Payout(
      id: id,
      groupId: groupId,
      memberId: memberId,
      amount: amount,
      date: date,
      cycleNumber: cycleNumber,
    );
  }

  factory PayoutModel.fromEntity(Payout payout) {
    return PayoutModel(
      id: payout.id,
      groupId: payout.groupId,
      memberId: payout.memberId,
      amount: payout.amount,
      date: payout.date,
      cycleNumber: payout.cycleNumber,
    );
  }
}
