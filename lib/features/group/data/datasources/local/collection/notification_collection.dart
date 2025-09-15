import 'package:isar/isar.dart';
import '../../../models/notification_model.dart';

part 'notification_collection.g.dart';

@collection
class NotificationCollection {
  Id id = Isar.autoIncrement;

  @Index()
  late int userId;

  late String message;

  late bool isRead;

  late DateTime createdAt;

  NotificationCollection();

  NotificationModel toModel() {
    return NotificationModel(
      id: id,
      userId: userId,
      message: message,
      isRead: isRead,
      createdAt: createdAt,
    );
  }

  factory NotificationCollection.fromModel(NotificationModel model) {
    final collection = NotificationCollection();
    collection.id = model.id;
    collection.userId = model.userId;
    collection.message = model.message;
    collection.isRead = model.isRead;
    collection.createdAt = model.createdAt;
    return collection;
  }
}
