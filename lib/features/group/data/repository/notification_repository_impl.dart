import 'package:injectable/injectable.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/local/dao/notification_dao.dart';
import '../models/notification_model.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl extends BaseRepository
    implements NotificationRepository {
  final NotificationDAO _notificationDAO;

  NotificationRepositoryImpl(this._notificationDAO);

  @override
  Future<Notification> createNotification(Notification notification) async {
    final result = await handleException(
      () async {
        final notificationModel = NotificationModel.fromEntity(notification);
        final createdModel = await _notificationDAO.createNotification(
          notificationModel,
        );
        return createdModel.toEntity();
      },
      operationName: 'create notification',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (notification) => notification,
    );
  }

  @override
  Future<Notification> updateNotification(Notification notification) async {
    final result = await handleException(
      () async {
        final notificationModel = NotificationModel.fromEntity(notification);
        final updatedModel = await _notificationDAO.updateNotification(
          notificationModel,
        );
        return updatedModel.toEntity();
      },
      operationName: 'update notification',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (notification) => notification,
    );
  }

  @override
  Future<void> deleteNotification(int notificationId) async {
    final result = await handleVoidException(
      () => _notificationDAO.deleteNotification(notificationId),
      operationName: 'delete notification',
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => null,
    );
  }

  @override
  Future<Notification?> getNotificationById(int notificationId) async {
    final result = await handleException(
      () async {
        final notificationModel = await _notificationDAO.getNotificationById(
          notificationId,
        );
        return notificationModel?.toEntity();
      },
      operationName: 'get notification by ID',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (notification) => notification,
    );
  }

  @override
  Future<List<Notification>> getNotificationsByUserId(int userId) async {
    final result = await handleException(
      () async {
        final notificationModels = await _notificationDAO
            .getNotificationsByUserId(userId);
        return notificationModels.map((model) => model.toEntity()).toList();
      },
      operationName: 'get notifications by user ID',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (notifications) => notifications,
    );
  }

  @override
  Future<List<Notification>> getUnreadNotificationsByUserId(int userId) async {
    final result = await handleException(
      () async {
        final notificationModels = await _notificationDAO
            .getUnreadNotificationsByUserId(userId);
        return notificationModels.map((model) => model.toEntity()).toList();
      },
      operationName: 'get unread notifications by user ID',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (notifications) => notifications,
    );
  }

  @override
  Future<void> markNotificationAsRead(int notificationId) async {
    final result = await handleVoidException(
      () => _notificationDAO.markNotificationAsRead(notificationId),
      operationName: 'mark notification as read',
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => null,
    );
  }

  @override
  Future<void> markAllNotificationsAsRead(int userId) async {
    final result = await handleVoidException(
      () => _notificationDAO.markAllNotificationsAsRead(userId),
      operationName: 'mark all notifications as read',
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => null,
    );
  }

  @override
  Future<int> getUnreadNotificationCount(int userId) async {
    final result = await handleException(
      () => _notificationDAO.getUnreadNotificationCount(userId),
      operationName: 'get unread notification count',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (count) => count,
    );
  }
}
