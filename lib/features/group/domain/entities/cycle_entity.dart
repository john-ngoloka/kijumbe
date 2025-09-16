import 'package:equatable/equatable.dart';

class Cycle extends Equatable {
  final int id;
  final int groupId;
  final int cycleNumber; // 1st, 2nd, etc.
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? deadline; // Contribution deadline
  final bool isActive;
  final double targetAmount; // Total target for this cycle
  final double currentAmount; // Current collected amount

  const Cycle({
    required this.id,
    required this.groupId,
    required this.cycleNumber,
    required this.startDate,
    this.endDate,
    this.deadline,
    required this.isActive,
    required this.targetAmount,
    required this.currentAmount,
  });

  @override
  List<Object?> get props => [
    id,
    groupId,
    cycleNumber,
    startDate,
    endDate,
    deadline,
    isActive,
    targetAmount,
    currentAmount,
  ];
}
