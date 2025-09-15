import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class CreateNotificationUseCase {
  final NotificationRepository repository;

  CreateNotificationUseCase(this.repository);

  Future<Either<Failure, Notification>> call(
    CreateNotificationParams params,
  ) async {
    try {
      final notification = Notification(
        id: params.id,
        userId: params.userId,
        message: params.message,
        isRead: false,
        createdAt: DateTime.now(),
      );

      final result = await repository.createNotification(notification);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class CreateNotificationParams {
  final int id;
  final int userId;
  final String message;

  CreateNotificationParams({
    required this.id,
    required this.userId,
    required this.message,
  });
}
