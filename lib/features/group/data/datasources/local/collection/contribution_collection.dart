import 'package:isar/isar.dart';
import '../../../models/contribution_model.dart';

part 'contribution_collection.g.dart';

@collection
class ContributionCollection {
  Id id = Isar.autoIncrement;

  @Index()
  late int groupId;

  @Index()
  late int memberId;

  @Index()
  late int cycleId;

  late double amount;

  late DateTime date;

  late bool isPaid; // true if paid, false if pending

  String? notes;

  ContributionCollection();

  ContributionModel toModel() {
    return ContributionModel(
      id: id,
      groupId: groupId,
      memberId: memberId,
      cycleId: cycleId,
      amount: amount,
      date: date,
      isPaid: isPaid,
      notes: notes,
    );
  }

  factory ContributionCollection.fromModel(ContributionModel model) {
    final collection = ContributionCollection();
    collection.id = model.id;
    collection.groupId = model.groupId;
    collection.memberId = model.memberId;
    collection.cycleId = model.cycleId;
    collection.amount = model.amount;
    collection.date = model.date;
    collection.isPaid = model.isPaid;
    collection.notes = model.notes;
    return collection;
  }
}
