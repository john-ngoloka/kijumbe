import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
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

    try {
      // Get the application documents directory
      final dir = await getApplicationSupportDirectory();

      // Ensure the directory exists
      if (!await Directory(dir.path).exists()) {
        await Directory(dir.path).create(recursive: true);
      }

      print('Initializing Isar database in: ${dir.path}');

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
        directory: dir.path,
      );

      print('Isar database initialized successfully');
      return _isar!;
    } catch (e) {
      // If there's an error, try to create a new instance
      _isar = null;
      print('Isar database error: $e');
      rethrow;
    }
  }

  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
