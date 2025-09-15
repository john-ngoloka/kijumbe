import 'package:isar/isar.dart';
import '../../../../../../core/database/app_database.dart';
import '../../../../../../core/errors/exceptions.dart';
import '../../../models/notification_model.dart';
import '../collection/notification_collection.dart';

class NotificationDAO {
  Future<Isar> get _isar async => await AppDatabase.instance;

  /// Create a new notification
  Future<NotificationModel> createNotification(
    NotificationModel notificationModel,
  ) async {
    try {
      final isar = await _isar;
      final notificationCollection = NotificationCollection.fromModel(
        notificationModel,
      );

      await isar.writeTxn(() async {
        await isar.notificationCollections.put(notificationCollection);
      });

      return notificationCollection.toModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to create notification: ${e.toString()}',
      );
    }
  }

  /// Update an existing notification
  Future<NotificationModel> updateNotification(
    NotificationModel notificationModel,
  ) async {
    try {
      final isar = await _isar;
      final notificationCollection = NotificationCollection.fromModel(
        notificationModel,
      );

      await isar.writeTxn(() async {
        await isar.notificationCollections.put(notificationCollection);
      });

      return notificationCollection.toModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to update notification: ${e.toString()}',
      );
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(int notificationId) async {
    try {
      final isar = await _isar;

      await isar.writeTxn(() async {
        await isar.notificationCollections
            .filter()
            .idEqualTo(notificationId)
            .deleteAll();
      });
    } catch (e) {
      throw CacheException(
        message: 'Failed to delete notification: ${e.toString()}',
      );
    }
  }

  /// Get a notification by ID
  Future<NotificationModel?> getNotificationById(int notificationId) async {
    try {
      final isar = await _isar;
      final notificationCollection = await isar.notificationCollections
          .filter()
          .idEqualTo(notificationId)
          .findFirst();

      return notificationCollection?.toModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get notification by ID: ${e.toString()}',
      );
    }
  }

  /// Get all notifications for a user
  Future<List<NotificationModel>> getNotificationsByUserId(int userId) async {
    try {
      final isar = await _isar;
      final notificationCollections = await isar.notificationCollections
          .filter()
          .userIdEqualTo(userId)
          .sortByCreatedAtDesc()
          .findAll();

      return notificationCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get notifications by user ID: ${e.toString()}',
      );
    }
  }

  /// Get unread notifications for a user
  Future<List<NotificationModel>> getUnreadNotificationsByUserId(
    int userId,
  ) async {
    try {
      final isar = await _isar;
      final notificationCollections = await isar.notificationCollections
          .filter()
          .userIdEqualTo(userId)
          .and()
          .isReadEqualTo(false)
          .sortByCreatedAtDesc()
          .findAll();

      return notificationCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get unread notifications: ${e.toString()}',
      );
    }
  }

  /// Mark a notification as read
  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      final isar = await _isar;

      await isar.writeTxn(() async {
        final notification = await isar.notificationCollections
            .filter()
            .idEqualTo(notificationId)
            .findFirst();

        if (notification != null) {
          notification.isRead = true;
          await isar.notificationCollections.put(notification);
        }
      });
    } catch (e) {
      throw CacheException(
        message: 'Failed to mark notification as read: ${e.toString()}',
      );
    }
  }

  /// Mark all notifications as read for a user
  Future<void> markAllNotificationsAsRead(int userId) async {
    try {
      final isar = await _isar;

      await isar.writeTxn(() async {
        final notifications = await isar.notificationCollections
            .filter()
            .userIdEqualTo(userId)
            .and()
            .isReadEqualTo(false)
            .findAll();

        for (final notification in notifications) {
          notification.isRead = true;
          await isar.notificationCollections.put(notification);
        }
      });
    } catch (e) {
      throw CacheException(
        message: 'Failed to mark all notifications as read: ${e.toString()}',
      );
    }
  }

  /// Get unread notification count for a user
  Future<int> getUnreadNotificationCount(int userId) async {
    try {
      final isar = await _isar;
      return await isar.notificationCollections
          .filter()
          .userIdEqualTo(userId)
          .and()
          .isReadEqualTo(false)
          .count();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get unread notification count: ${e.toString()}',
      );
    }
  }

  /// Get notifications within a date range
  Future<List<NotificationModel>> getNotificationsByDateRange(
    int userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final isar = await _isar;
      final notificationCollections = await isar.notificationCollections
          .filter()
          .userIdEqualTo(userId)
          .and()
          .createdAtBetween(startDate, endDate)
          .sortByCreatedAtDesc()
          .findAll();

      return notificationCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get notifications by date range: ${e.toString()}',
      );
    }
  }

  /// Get recent notifications for a user (last N days)
  Future<List<NotificationModel>> getRecentNotifications(
    int userId,
    int days,
  ) async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: days));

      return await getNotificationsByDateRange(userId, startDate, endDate);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get recent notifications: ${e.toString()}',
      );
    }
  }

  /// Get notification count for a user
  Future<int> getNotificationCountByUserId(int userId) async {
    try {
      final isar = await _isar;
      return await isar.notificationCollections
          .filter()
          .userIdEqualTo(userId)
          .count();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get notification count: ${e.toString()}',
      );
    }
  }

  /// Delete old notifications (older than specified days)
  Future<void> deleteOldNotifications(int userId, int days) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: days));
      final isar = await _isar;

      await isar.writeTxn(() async {
        await isar.notificationCollections
            .filter()
            .userIdEqualTo(userId)
            .and()
            .createdAtLessThan(cutoffDate)
            .deleteAll();
      });
    } catch (e) {
      throw CacheException(
        message: 'Failed to delete old notifications: ${e.toString()}',
      );
    }
  }

  /// Get notifications by message content (search)
  Future<List<NotificationModel>> searchNotificationsByMessage(
    int userId,
    String searchTerm,
  ) async {
    try {
      final isar = await _isar;
      final notificationCollections = await isar.notificationCollections
          .filter()
          .userIdEqualTo(userId)
          .and()
          .messageContains(searchTerm, caseSensitive: false)
          .sortByCreatedAtDesc()
          .findAll();

      return notificationCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to search notifications: ${e.toString()}',
      );
    }
  }

  /// Get latest notification for a user
  Future<NotificationModel?> getLatestNotificationByUserId(int userId) async {
    try {
      final isar = await _isar;
      final notificationCollection = await isar.notificationCollections
          .filter()
          .userIdEqualTo(userId)
          .sortByCreatedAtDesc()
          .findFirst();

      return notificationCollection?.toModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get latest notification: ${e.toString()}',
      );
    }
  }

  /// Clear all notifications for a user
  Future<void> clearAllNotifications(int userId) async {
    try {
      final isar = await _isar;

      await isar.writeTxn(() async {
        await isar.notificationCollections
            .filter()
            .userIdEqualTo(userId)
            .deleteAll();
      });
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear all notifications: ${e.toString()}',
      );
    }
  }

  /// Get notifications by read status
  Future<List<NotificationModel>> getNotificationsByReadStatus(
    int userId,
    bool isRead,
  ) async {
    try {
      final isar = await _isar;
      final notificationCollections = await isar.notificationCollections
          .filter()
          .userIdEqualTo(userId)
          .and()
          .isReadEqualTo(isRead)
          .sortByCreatedAtDesc()
          .findAll();

      return notificationCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get notifications by read status: ${e.toString()}',
      );
    }
  }
}
