import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import '../../../../../../core/database/app_database.dart';
import '../../../../../../core/errors/exceptions.dart';
import '../../../models/payout_model.dart';
import '../collection/payout_collection.dart';

@injectable
class PayoutDAO {
  Future<Isar> get _isar async => await AppDatabase.instance;

  /// Record a new payout
  Future<PayoutModel> recordPayout(PayoutModel payoutModel) async {
    try {
      final isar = await _isar;
      final payoutCollection = PayoutCollection.fromModel(payoutModel);

      await isar.writeTxn(() async {
        await isar.payoutCollections.put(payoutCollection);
      });

      return payoutCollection.toModel();
    } catch (e) {
      throw CacheException(message: 'Failed to record payout: ${e.toString()}');
    }
  }

  /// Update an existing payout
  Future<PayoutModel> updatePayout(PayoutModel payoutModel) async {
    try {
      final isar = await _isar;
      final payoutCollection = PayoutCollection.fromModel(payoutModel);

      await isar.writeTxn(() async {
        await isar.payoutCollections.put(payoutCollection);
      });

      return payoutCollection.toModel();
    } catch (e) {
      throw CacheException(message: 'Failed to update payout: ${e.toString()}');
    }
  }

  /// Delete a payout
  Future<void> deletePayout(int payoutId) async {
    try {
      final isar = await _isar;

      await isar.writeTxn(() async {
        await isar.payoutCollections.filter().idEqualTo(payoutId).deleteAll();
      });
    } catch (e) {
      throw CacheException(message: 'Failed to delete payout: ${e.toString()}');
    }
  }

  /// Get a payout by ID
  Future<PayoutModel?> getPayoutById(int payoutId) async {
    try {
      final isar = await _isar;
      final payoutCollection = await isar.payoutCollections
          .filter()
          .idEqualTo(payoutId)
          .findFirst();

      return payoutCollection?.toModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get payout by ID: ${e.toString()}',
      );
    }
  }

  /// Get all payouts for a group
  Future<List<PayoutModel>> getPayoutsByGroupId(int groupId) async {
    try {
      final isar = await _isar;
      final payoutCollections = await isar.payoutCollections
          .filter()
          .groupIdEqualTo(groupId)
          .sortByDate()
          .findAll();

      return payoutCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get payouts by group ID: ${e.toString()}',
      );
    }
  }

  /// Get all payouts for a member
  Future<List<PayoutModel>> getPayoutsByMemberId(int memberId) async {
    try {
      final isar = await _isar;
      final payoutCollections = await isar.payoutCollections
          .filter()
          .memberIdEqualTo(memberId)
          .sortByDate()
          .findAll();

      return payoutCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get payouts by member ID: ${e.toString()}',
      );
    }
  }

  /// Get payouts for a specific cycle
  Future<List<PayoutModel>> getPayoutsByCycle(
    int groupId,
    int cycleNumber,
  ) async {
    try {
      final isar = await _isar;
      final payoutCollections = await isar.payoutCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .cycleNumberEqualTo(cycleNumber)
          .sortByDate()
          .findAll();

      return payoutCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get payouts by cycle: ${e.toString()}',
      );
    }
  }

  /// Get total payouts amount for a group
  Future<double> getTotalPayoutsByGroup(int groupId) async {
    try {
      final isar = await _isar;
      final total = await isar.payoutCollections
          .filter()
          .groupIdEqualTo(groupId)
          .amountProperty()
          .sum();

      return total;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get total payouts by group: ${e.toString()}',
      );
    }
  }

  /// Get total payouts amount for a member
  Future<double> getTotalPayoutsByMember(int memberId) async {
    try {
      final isar = await _isar;
      final total = await isar.payoutCollections
          .filter()
          .memberIdEqualTo(memberId)
          .amountProperty()
          .sum();

      return total ?? 0.0;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get total payouts by member: ${e.toString()}',
      );
    }
  }

  /// Get payouts within a date range
  Future<List<PayoutModel>> getPayoutsByDateRange(
    int groupId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final isar = await _isar;
      final payoutCollections = await isar.payoutCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .dateBetween(startDate, endDate)
          .sortByDate()
          .findAll();

      return payoutCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get payouts by date range: ${e.toString()}',
      );
    }
  }

  /// Get payouts for a specific member in a group
  Future<List<PayoutModel>> getPayoutsByMemberInGroup(
    int groupId,
    int memberId,
  ) async {
    try {
      final isar = await _isar;
      final payoutCollections = await isar.payoutCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .memberIdEqualTo(memberId)
          .sortByDate()
          .findAll();

      return payoutCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get payouts by member in group: ${e.toString()}',
      );
    }
  }

  /// Get payout count for a group
  Future<int> getPayoutCountByGroup(int groupId) async {
    try {
      final isar = await _isar;
      return await isar.payoutCollections
          .filter()
          .groupIdEqualTo(groupId)
          .count();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get payout count: ${e.toString()}',
      );
    }
  }

  /// Get payout count for a member
  Future<int> getPayoutCountByMember(int memberId) async {
    try {
      final isar = await _isar;
      return await isar.payoutCollections
          .filter()
          .memberIdEqualTo(memberId)
          .count();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get payout count by member: ${e.toString()}',
      );
    }
  }

  /// Get latest payout for a member
  Future<PayoutModel?> getLatestPayoutByMember(int memberId) async {
    try {
      final isar = await _isar;
      final payoutCollection = await isar.payoutCollections
          .filter()
          .memberIdEqualTo(memberId)
          .sortByDateDesc()
          .findFirst();

      return payoutCollection?.toModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get latest payout: ${e.toString()}',
      );
    }
  }

  /// Get total payouts for a specific cycle
  Future<double> getTotalPayoutsByCycle(int groupId, int cycleNumber) async {
    try {
      final isar = await _isar;
      final total = await isar.payoutCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .cycleNumberEqualTo(cycleNumber)
          .amountProperty()
          .sum();

      return total ?? 0.0;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get total payouts by cycle: ${e.toString()}',
      );
    }
  }

  /// Get average payout amount for a group
  Future<double> getAveragePayoutByGroup(int groupId) async {
    try {
      final isar = await _isar;
      final total = await isar.payoutCollections
          .filter()
          .groupIdEqualTo(groupId)
          .amountProperty()
          .sum();
      final count = await isar.payoutCollections
          .filter()
          .groupIdEqualTo(groupId)
          .count();

      if (count == 0) return 0.0;
      return (total ?? 0.0) / count;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get average payout: ${e.toString()}',
      );
    }
  }

  /// Check if member has received payout in a cycle
  Future<bool> hasMemberReceivedPayoutInCycle(
    int groupId,
    int memberId,
    int cycleNumber,
  ) async {
    try {
      final isar = await _isar;
      final count = await isar.payoutCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .memberIdEqualTo(memberId)
          .and()
          .cycleNumberEqualTo(cycleNumber)
          .count();

      return count > 0;
    } catch (e) {
      throw CacheException(
        message: 'Failed to check payout in cycle: ${e.toString()}',
      );
    }
  }

  /// Get all unique cycle numbers for a group
  Future<List<int>> getCycleNumbersByGroup(int groupId) async {
    try {
      final isar = await _isar;
      final payouts = await isar.payoutCollections
          .filter()
          .groupIdEqualTo(groupId)
          .findAll();

      final cycleNumbers = payouts
          .map((payout) => payout.cycleNumber)
          .toSet()
          .toList();
      cycleNumbers.sort();
      return cycleNumbers;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get cycle numbers: ${e.toString()}',
      );
    }
  }
}
