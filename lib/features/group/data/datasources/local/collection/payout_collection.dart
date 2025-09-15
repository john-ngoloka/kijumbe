import 'package:isar/isar.dart';
import '../../../models/payout_model.dart';

part 'payout_collection.g.dart';

@collection
class PayoutCollection {
  Id id = Isar.autoIncrement;

  @Index()
  late int groupId;

  @Index()
  late int memberId; // who received the payout

  late double amount;

  late DateTime date;

  late int cycleNumber; // to track which cycle

  PayoutCollection();

  PayoutModel toModel() {
    return PayoutModel(
      id: id,
      groupId: groupId,
      memberId: memberId,
      amount: amount,
      date: date,
      cycleNumber: cycleNumber,
    );
  }

  factory PayoutCollection.fromModel(PayoutModel model) {
    final collection = PayoutCollection();
    collection.id = model.id;
    collection.groupId = model.groupId;
    collection.memberId = model.memberId;
    collection.amount = model.amount;
    collection.date = model.date;
    collection.cycleNumber = model.cycleNumber;
    return collection;
  }
}
