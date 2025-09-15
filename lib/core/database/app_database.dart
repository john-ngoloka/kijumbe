import 'package:isar/isar.dart';
import '../../core/constants/app_constants.dart';
import '../../features/authentication/data/datasources/local/collection/user_collection.dart';
import '../../features/group/data/datasources/local/collection/group_collection.dart';
import '../../features/group/data/datasources/local/collection/group_member_collection.dart';
import '../../features/group/data/datasources/local/collection/contribution_collection.dart';
import '../../features/group/data/datasources/local/collection/payout_collection.dart';
import '../../features/group/data/datasources/local/collection/cycle_collection.dart';
import '../../features/group/data/datasources/local/collection/notification_collection.dart';

class AppDatabase {
  static Isar? _isar;

  static Future<Isar> get instance async {
    if (_isar != null) {
      return _isar!;
    }

    _isar = await Isar.open(
      [
        UserSchema,
        GroupSchema,
        GroupMemberCollectionSchema,
        ContributionCollectionSchema,
        PayoutCollectionSchema,
        CycleCollectionSchema,
        NotificationCollectionSchema,
      ],
      name: AppConstants.databaseName,
      directory: 'kijumbe_db',
    );

    return _isar!;
  }

  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
