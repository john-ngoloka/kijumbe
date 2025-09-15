import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Notification> createNotification(Notification notification);
  Future<Notification> updateNotification(Notification notification);
  Future<void> deleteNotification(int notificationId);
  Future<Notification?> getNotificationById(int notificationId);
  Future<List<Notification>> getNotificationsByUserId(int userId);
  Future<List<Notification>> getUnreadNotificationsByUserId(int userId);
  Future<void> markNotificationAsRead(int notificationId);
  Future<void> markAllNotificationsAsRead(int userId);
  Future<int> getUnreadNotificationCount(int userId);
}
