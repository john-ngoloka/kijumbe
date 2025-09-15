import 'package:isar/isar.dart';
import '../../../../../../core/database/app_database.dart';
import '../../../../../../core/errors/exceptions.dart';
import '../../../models/cycle_model.dart';
import '../collection/cycle_collection.dart';

class CycleDAO {
  Future<Isar> get _isar async => await AppDatabase.instance;

  /// Create a new cycle
  Future<CycleModel> createCycle(CycleModel cycleModel) async {
    try {
      final isar = await _isar;
      final cycleCollection = CycleCollection.fromModel(cycleModel);

      await isar.writeTxn(() async {
        await isar.cycleCollections.put(cycleCollection);
      });

      return cycleCollection.toModel();
    } catch (e) {
      throw CacheException(message: 'Failed to create cycle: ${e.toString()}');
    }
  }

  /// Update an existing cycle
  Future<CycleModel> updateCycle(CycleModel cycleModel) async {
    try {
      final isar = await _isar;
      final cycleCollection = CycleCollection.fromModel(cycleModel);

      await isar.writeTxn(() async {
        await isar.cycleCollections.put(cycleCollection);
      });

      return cycleCollection.toModel();
    } catch (e) {
      throw CacheException(message: 'Failed to update cycle: ${e.toString()}');
    }
  }

  /// Delete a cycle
  Future<void> deleteCycle(int cycleId) async {
    try {
      final isar = await _isar;

      await isar.writeTxn(() async {
        await isar.cycleCollections.filter().idEqualTo(cycleId).deleteAll();
      });
    } catch (e) {
      throw CacheException(message: 'Failed to delete cycle: ${e.toString()}');
    }
  }

  /// Get a cycle by ID
  Future<CycleModel?> getCycleById(int cycleId) async {
    try {
      final isar = await _isar;
      final cycleCollection = await isar.cycleCollections
          .filter()
          .idEqualTo(cycleId)
          .findFirst();

      return cycleCollection?.toModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get cycle by ID: ${e.toString()}',
      );
    }
  }

  /// Get all cycles for a group
  Future<List<CycleModel>> getCyclesByGroupId(int groupId) async {
    try {
      final isar = await _isar;
      final cycleCollections = await isar.cycleCollections
          .filter()
          .groupIdEqualTo(groupId)
          .sortByCycleNumber()
          .findAll();

      return cycleCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get cycles by group ID: ${e.toString()}',
      );
    }
  }

  /// Get the active cycle for a group
  Future<CycleModel?> getActiveCycleByGroupId(int groupId) async {
    try {
      final isar = await _isar;
      final cycleCollection = await isar.cycleCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .isActiveEqualTo(true)
          .findFirst();

      return cycleCollection?.toModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get active cycle: ${e.toString()}',
      );
    }
  }

  /// Get completed cycles for a group
  Future<List<CycleModel>> getCompletedCyclesByGroupId(int groupId) async {
    try {
      final isar = await _isar;
      final cycleCollections = await isar.cycleCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .isActiveEqualTo(false)
          .sortByCycleNumberDesc()
          .findAll();

      return cycleCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get completed cycles: ${e.toString()}',
      );
    }
  }

  /// Start a new cycle for a group
  Future<CycleModel> startNewCycle(int groupId, int cycleNumber) async {
    try {
      final isar = await _isar;

      // First, close any existing active cycle
      await isar.writeTxn(() async {
        final activeCycles = await isar.cycleCollections
            .filter()
            .groupIdEqualTo(groupId)
            .and()
            .isActiveEqualTo(true)
            .findAll();

        for (final cycle in activeCycles) {
          cycle.isActive = false;
          cycle.endDate = DateTime.now();
          await isar.cycleCollections.put(cycle);
        }
      });

      // Create new cycle
      final newCycle = CycleModel(
        id: DateTime.now().millisecondsSinceEpoch, // Simple ID generation
        groupId: groupId,
        cycleNumber: cycleNumber,
        startDate: DateTime.now(),
        endDate: null,
        isActive: true,
      );

      return await createCycle(newCycle);
    } catch (e) {
      throw CacheException(
        message: 'Failed to start new cycle: ${e.toString()}',
      );
    }
  }

  /// Close a cycle
  Future<CycleModel> closeCycle(int cycleId) async {
    try {
      final isar = await _isar;

      await isar.writeTxn(() async {
        final cycle = await isar.cycleCollections
            .filter()
            .idEqualTo(cycleId)
            .findFirst();

        if (cycle != null) {
          cycle.isActive = false;
          cycle.endDate = DateTime.now();
          await isar.cycleCollections.put(cycle);
        }
      });

      final updatedCycle = await getCycleById(cycleId);
      if (updatedCycle == null) {
        throw CacheException(message: 'Cycle not found after update');
      }

      return updatedCycle;
    } catch (e) {
      throw CacheException(message: 'Failed to close cycle: ${e.toString()}');
    }
  }

  /// Get the next cycle number for a group
  Future<int> getNextCycleNumber(int groupId) async {
    try {
      final isar = await _isar;
      final cycles = await isar.cycleCollections
          .filter()
          .groupIdEqualTo(groupId)
          .sortByCycleNumberDesc()
          .findAll();

      if (cycles.isEmpty) {
        return 1;
      }

      return cycles.first.cycleNumber + 1;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get next cycle number: ${e.toString()}',
      );
    }
  }

  /// Get cycle by group and cycle number
  Future<CycleModel?> getCycleByGroupAndNumber(
    int groupId,
    int cycleNumber,
  ) async {
    try {
      final isar = await _isar;
      final cycleCollection = await isar.cycleCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .cycleNumberEqualTo(cycleNumber)
          .findFirst();

      return cycleCollection?.toModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get cycle by group and number: ${e.toString()}',
      );
    }
  }

  /// Get cycles within a date range
  Future<List<CycleModel>> getCyclesByDateRange(
    int groupId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final isar = await _isar;
      final cycleCollections = await isar.cycleCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .startDateBetween(startDate, endDate)
          .sortByStartDate()
          .findAll();

      return cycleCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get cycles by date range: ${e.toString()}',
      );
    }
  }

  /// Get cycle count for a group
  Future<int> getCycleCountByGroup(int groupId) async {
    try {
      final isar = await _isar;
      return await isar.cycleCollections
          .filter()
          .groupIdEqualTo(groupId)
          .count();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get cycle count: ${e.toString()}',
      );
    }
  }

  /// Check if group has an active cycle
  Future<bool> hasActiveCycle(int groupId) async {
    try {
      final isar = await _isar;
      final count = await isar.cycleCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .isActiveEqualTo(true)
          .count();

      return count > 0;
    } catch (e) {
      throw CacheException(
        message: 'Failed to check active cycle: ${e.toString()}',
      );
    }
  }

  /// Get the latest cycle for a group
  Future<CycleModel?> getLatestCycleByGroup(int groupId) async {
    try {
      final isar = await _isar;
      final cycleCollection = await isar.cycleCollections
          .filter()
          .groupIdEqualTo(groupId)
          .sortByCycleNumberDesc()
          .findFirst();

      return cycleCollection?.toModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get latest cycle: ${e.toString()}',
      );
    }
  }
}
