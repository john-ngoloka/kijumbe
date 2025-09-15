import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final int id;
  final int userId;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const Notification({
    required this.id,
    required this.userId,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, message, isRead, createdAt];
}
