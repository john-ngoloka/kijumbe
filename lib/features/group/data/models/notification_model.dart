import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/notification_entity.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    required String message,
    @JsonKey(name: 'is_read') required bool isRead,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _NotificationModel;

  const NotificationModel._();

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Notification toEntity() {
    return Notification(
      id: id,
      userId: userId,
      message: message,
      isRead: isRead,
      createdAt: createdAt,
    );
  }

  factory NotificationModel.fromEntity(Notification notification) {
    return NotificationModel(
      id: notification.id,
      userId: notification.userId,
      message: notification.message,
      isRead: notification.isRead,
      createdAt: notification.createdAt,
    );
  }
}
