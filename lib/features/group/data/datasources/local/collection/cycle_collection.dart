import 'package:isar/isar.dart';
import '../../../models/cycle_model.dart';

part 'cycle_collection.g.dart';

@collection
class CycleCollection {
  Id id = Isar.autoIncrement;

  @Index()
  late int groupId;

  late int cycleNumber; // 1st, 2nd, etc.

  late DateTime startDate;

  DateTime? endDate;

  DateTime? deadline;

  late bool isActive;

  late double targetAmount;

  late double currentAmount;

  CycleCollection();

  CycleModel toModel() {
    return CycleModel(
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

  factory CycleCollection.fromModel(CycleModel model) {
    final collection = CycleCollection();
    collection.id = model.id;
    collection.groupId = model.groupId;
    collection.cycleNumber = model.cycleNumber;
    collection.startDate = model.startDate;
    collection.endDate = model.endDate;
    collection.deadline = model.deadline;
    collection.isActive = model.isActive;
    collection.targetAmount = model.targetAmount;
    collection.currentAmount = model.currentAmount;
    return collection;
  }
}
