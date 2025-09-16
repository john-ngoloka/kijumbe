import 'package:equatable/equatable.dart';

class Contribution extends Equatable {
  final int id;
  final int groupId;
  final int memberId;
  final int cycleId; // Link to specific cycle
  final double amount;
  final DateTime date;
  final bool isPaid; // true if paid, false if pending
  final String? notes; // Optional notes for the contribution

  const Contribution({
    required this.id,
    required this.groupId,
    required this.memberId,
    required this.cycleId,
    required this.amount,
    required this.date,
    required this.isPaid,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    groupId,
    memberId,
    cycleId,
    amount,
    date,
    isPaid,
    notes,
  ];
}
