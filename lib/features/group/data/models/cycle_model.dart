import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/cycle_entity.dart';

part 'cycle_model.freezed.dart';
part 'cycle_model.g.dart';

@freezed
class CycleModel with _$CycleModel {
  const factory CycleModel({
    required int id,
    @JsonKey(name: 'group_id') required int groupId,
    @JsonKey(name: 'cycle_number') required int cycleNumber,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'deadline') DateTime? deadline,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'target_amount') required double targetAmount,
    @JsonKey(name: 'current_amount') required double currentAmount,
  }) = _CycleModel;

  const CycleModel._();

  factory CycleModel.fromJson(Map<String, dynamic> json) =>
      _$CycleModelFromJson(json);

  Cycle toEntity() {
    return Cycle(
      id: id,
      groupId: groupId,
      cycleNumber: cycleNumber,
      startDate: startDate,
      endDate: endDate,
      deadline: deadline,
      isActive: isActive,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
    );
  }

  factory CycleModel.fromEntity(Cycle cycle) {
    return CycleModel(
      id: cycle.id,
      groupId: cycle.groupId,
      cycleNumber: cycle.cycleNumber,
      startDate: cycle.startDate,
      endDate: cycle.endDate,
      deadline: cycle.deadline,
      isActive: cycle.isActive,
      targetAmount: cycle.targetAmount,
      currentAmount: cycle.currentAmount,
    );
  }
}
