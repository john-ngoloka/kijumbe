import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetUnreadNotificationsUseCase {
  final NotificationRepository repository;

  GetUnreadNotificationsUseCase(this.repository);

  Future<Either<Failure, List<Notification>>> call(int userId) async {
    try {
      final result = await repository.getUnreadNotificationsByUserId(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
