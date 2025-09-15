import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsByUserUseCase {
  final NotificationRepository repository;

  GetNotificationsByUserUseCase(this.repository);

  Future<Either<Failure, List<Notification>>> call(int userId) async {
    try {
      final result = await repository.getNotificationsByUserId(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
