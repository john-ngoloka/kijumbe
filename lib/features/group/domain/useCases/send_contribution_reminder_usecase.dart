import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/group_member_repository.dart';
import '../repositories/notification_repository.dart';

class SendContributionReminderUseCase {
  final GroupMemberRepository groupMemberRepository;
  final NotificationRepository notificationRepository;

  SendContributionReminderUseCase(
    this.groupMemberRepository,
    this.notificationRepository,
  );

  Future<Either<Failure, List<Notification>>> call(int groupId) async {
    try {
      final members = await groupMemberRepository.getMembersByGroupId(groupId);
      final notifications = <Notification>[];

      for (final member in members.where((m) => m.isActive)) {
        final notification = Notification(
          id:
              DateTime.now().millisecondsSinceEpoch +
              member.id, // Simple ID generation
          userId: member.userId,
          message:
              "Reminder: Your contribution is due. Please make your payment to continue participating in the group.",
          isRead: false,
          createdAt: DateTime.now(),
        );

        final createdNotification = await notificationRepository
            .createNotification(notification);
        notifications.add(createdNotification);
      }

      return Right(notifications);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
