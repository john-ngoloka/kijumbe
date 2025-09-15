import 'package:equatable/equatable.dart';

class Contribution extends Equatable {
  final int id;
  final int groupId;
  final int memberId;
  final double amount;
  final DateTime date;
  final bool isPaid; // true if paid, false if pending

  const Contribution({
    required this.id,
    required this.groupId,
    required this.memberId,
    required this.amount,
    required this.date,
    required this.isPaid,
  });

  @override
  List<Object?> get props => [id, groupId, memberId, amount, date, isPaid];
}
