import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/notification_repository.dart';

class GetUnreadNotificationCountUseCase {
  final NotificationRepository repository;

  GetUnreadNotificationCountUseCase(this.repository);

  Future<Either<Failure, int>> call(int userId) async {
    try {
      final result = await repository.getUnreadNotificationCount(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
