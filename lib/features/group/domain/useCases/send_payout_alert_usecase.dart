import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class SendPayoutAlertUseCase {
  final NotificationRepository notificationRepository;

  SendPayoutAlertUseCase(this.notificationRepository);

  Future<Either<Failure, Notification>> call(
    SendPayoutAlertParams params,
  ) async {
    try {
      final notification = Notification(
        id: params.id,
        userId: params.userId,
        message:
            "Congratulations! It's your turn to receive the payout of \$${params.amount.toStringAsFixed(2)}. Please contact the group admin to collect your funds.",
        isRead: false,
        createdAt: DateTime.now(),
      );

      final result = await notificationRepository.createNotification(
        notification,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class SendPayoutAlertParams {
  final int id;
  final int userId;
  final double amount;

  SendPayoutAlertParams({
    required this.id,
    required this.userId,
    required this.amount,
  });
}
