import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final String description;
  final int adminId;
  final double contributionAmount;
  final String frequency;
  final DateTime createdAt;

  const Group({
    required this.id,
    required this.name,
    required this.description,
    required this.adminId,
    required this.contributionAmount,
    required this.frequency,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, description, adminId, contributionAmount, frequency, createdAt];
}
