import 'package:equatable/equatable.dart';

class Payout extends Equatable {
  final int id;
  final int groupId;
  final int memberId; // who received the payout
  final double amount;
  final DateTime date;
  final int cycleNumber; // to track which cycle

  const Payout({
    required this.id,
    required this.groupId,
    required this.memberId,
    required this.amount,
    required this.date,
    required this.cycleNumber,
  });

  @override
  List<Object?> get props => [id, groupId, memberId, amount, date, cycleNumber];
}
