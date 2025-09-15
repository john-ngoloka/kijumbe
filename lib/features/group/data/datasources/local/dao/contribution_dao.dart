import 'package:isar/isar.dart';
import '../../../../../../core/database/app_database.dart';
import '../../../../../../core/errors/exceptions.dart';
import '../../../models/contribution_model.dart';
import '../collection/contribution_collection.dart';

class ContributionDAO {
  Future<Isar> get _isar async => await AppDatabase.instance;

  /// Record a new contribution
  Future<ContributionModel> recordContribution(
    ContributionModel contributionModel,
  ) async {
    try {
      final isar = await _isar;
      final contributionCollection = ContributionCollection.fromModel(
        contributionModel,
      );

      await isar.writeTxn(() async {
        await isar.contributionCollections.put(contributionCollection);
      });

      return contributionCollection.toModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to record contribution: ${e.toString()}',
      );
    }
  }

  /// Update an existing contribution
  Future<ContributionModel> updateContribution(
    ContributionModel contributionModel,
  ) async {
    try {
      final isar = await _isar;
      final contributionCollection = ContributionCollection.fromModel(
        contributionModel,
      );

      await isar.writeTxn(() async {
        await isar.contributionCollections.put(contributionCollection);
      });

      return contributionCollection.toModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to update contribution: ${e.toString()}',
      );
    }
  }

  /// Delete a contribution
  Future<void> deleteContribution(int contributionId) async {
    try {
      final isar = await _isar;

      await isar.writeTxn(() async {
        await isar.contributionCollections
            .filter()
            .idEqualTo(contributionId)
            .deleteAll();
      });
    } catch (e) {
      throw CacheException(
        message: 'Failed to delete contribution: ${e.toString()}',
      );
    }
  }

  /// Get a contribution by ID
  Future<ContributionModel?> getContributionById(int contributionId) async {
    try {
      final isar = await _isar;
      final contributionCollection = await isar.contributionCollections
          .filter()
          .idEqualTo(contributionId)
          .findFirst();

      return contributionCollection?.toModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get contribution by ID: ${e.toString()}',
      );
    }
  }

  /// Get all contributions for a group
  Future<List<ContributionModel>> getContributionsByGroupId(int groupId) async {
    try {
      final isar = await _isar;
      final contributionCollections = await isar.contributionCollections
          .filter()
          .groupIdEqualTo(groupId)
          .sortByDate()
          .findAll();

      return contributionCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get contributions by group ID: ${e.toString()}',
      );
    }
  }

  /// Get all contributions for a member
  Future<List<ContributionModel>> getContributionsByMemberId(
    int memberId,
  ) async {
    try {
      final isar = await _isar;
      final contributionCollections = await isar.contributionCollections
          .filter()
          .memberIdEqualTo(memberId)
          .sortByDate()
          .findAll();

      return contributionCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get contributions by member ID: ${e.toString()}',
      );
    }
  }

  /// Get pending (unpaid) contributions for a group
  Future<List<ContributionModel>> getPendingContributions(int groupId) async {
    try {
      final isar = await _isar;
      final contributionCollections = await isar.contributionCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .isPaidEqualTo(false)
          .sortByDate()
          .findAll();

      return contributionCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get pending contributions: ${e.toString()}',
      );
    }
  }

  /// Get paid contributions for a group
  Future<List<ContributionModel>> getPaidContributions(int groupId) async {
    try {
      final isar = await _isar;
      final contributionCollections = await isar.contributionCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .isPaidEqualTo(true)
          .sortByDate()
          .findAll();

      return contributionCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get paid contributions: ${e.toString()}',
      );
    }
  }

  /// Get total contributions amount for a group
  Future<double> getTotalContributionsByGroup(int groupId) async {
    try {
      final isar = await _isar;
      final total = await isar.contributionCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .isPaidEqualTo(true)
          .amountProperty()
          .sum();

      return total ?? 0.0;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get total contributions by group: ${e.toString()}',
      );
    }
  }

  /// Get total contributions amount for a member
  Future<double> getTotalContributionsByMember(int memberId) async {
    try {
      final isar = await _isar;
      final total = await isar.contributionCollections
          .filter()
          .memberIdEqualTo(memberId)
          .and()
          .isPaidEqualTo(true)
          .amountProperty()
          .sum();

      return total ?? 0.0;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get total contributions by member: ${e.toString()}',
      );
    }
  }

  /// Get contributions within a date range
  Future<List<ContributionModel>> getContributionsByDateRange(
    int groupId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final isar = await _isar;
      final contributionCollections = await isar.contributionCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .dateBetween(startDate, endDate)
          .sortByDate()
          .findAll();

      return contributionCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get contributions by date range: ${e.toString()}',
      );
    }
  }

  /// Get contributions for a specific member in a group
  Future<List<ContributionModel>> getContributionsByMemberInGroup(
    int groupId,
    int memberId,
  ) async {
    try {
      final isar = await _isar;
      final contributionCollections = await isar.contributionCollections
          .filter()
          .groupIdEqualTo(groupId)
          .and()
          .memberIdEqualTo(memberId)
          .sortByDate()
          .findAll();

      return contributionCollections
          .map((collection) => collection.toModel())
          .toList();
    } catch (e) {
      throw CacheException(
        message:
            'Failed to get contributions by member in group: ${e.toString()}',
      );
    }
  }

  /// Mark a contribution as paid
  Future<void> markContributionAsPaid(int contributionId) async {
    try {
      final isar = await _isar;

      await isar.writeTxn(() async {
        final contribution = await isar.contributionCollections
            .filter()
            .idEqualTo(contributionId)
            .findFirst();

        if (contribution != null) {
          contribution.isPaid = true;
          await isar.contributionCollections.put(contribution);
        }
      });
    } catch (e) {
      throw CacheException(
        message: 'Failed to mark contribution as paid: ${e.toString()}',
      );
    }
  }

  /// Get contribution count for a group
  Future<int> getContributionCountByGroup(int groupId) async {
    try {
      final isar = await _isar;
      return await isar.contributionCollections
          .filter()
          .groupIdEqualTo(groupId)
          .count();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get contribution count: ${e.toString()}',
      );
    }
  }

  /// Get latest contribution for a member
  Future<ContributionModel?> getLatestContributionByMember(int memberId) async {
    try {
      final isar = await _isar;
      final contributionCollection = await isar.contributionCollections
          .filter()
          .memberIdEqualTo(memberId)
          .sortByDateDesc()
          .findFirst();

      return contributionCollection?.toModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get latest contribution: ${e.toString()}',
      );
    }
  }
}
