import 'package:equatable/equatable.dart';

class Cycle extends Equatable {
  final int id;
  final int groupId;
  final int cycleNumber; // 1st, 2nd, etc.
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;

  const Cycle({
    required this.id,
    required this.groupId,
    required this.cycleNumber,
    required this.startDate,
    this.endDate,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
    id,
    groupId,
    cycleNumber,
    startDate,
    endDate,
    isActive,
  ];
}
