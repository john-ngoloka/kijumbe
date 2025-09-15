import 'package:injectable/injectable.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../domain/entities/contribution_entity.dart';
import '../../domain/repositories/contribution_repository.dart';
import '../datasources/local/dao/contribution_dao.dart';
import '../models/contribution_model.dart';

@LazySingleton(as: ContributionRepository)
class ContributionRepositoryImpl extends BaseRepository
    implements ContributionRepository {
  final ContributionDAO _contributionDAO;

  ContributionRepositoryImpl(this._contributionDAO);

  @override
  Future<Contribution> recordContribution(Contribution contribution) async {
    final result = await handleException(
      () async {
        final contributionModel = ContributionModel.fromEntity(contribution);
        final recordedModel = await _contributionDAO.recordContribution(
          contributionModel,
        );
        return recordedModel.toEntity();
      },
      operationName: 'record contribution',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (contribution) => contribution,
    );
  }

  @override
  Future<Contribution> updateContribution(Contribution contribution) async {
    final result = await handleException(
      () async {
        final contributionModel = ContributionModel.fromEntity(contribution);
        final updatedModel = await _contributionDAO.updateContribution(
          contributionModel,
        );
        return updatedModel.toEntity();
      },
      operationName: 'update contribution',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (contribution) => contribution,
    );
  }

  @override
  Future<void> deleteContribution(int contributionId) async {
    final result = await handleVoidException(
      () => _contributionDAO.deleteContribution(contributionId),
      operationName: 'delete contribution',
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => null,
    );
  }

  @override
  Future<Contribution?> getContributionById(int contributionId) async {
    final result = await handleException(
      () async {
        final contributionModel = await _contributionDAO.getContributionById(
          contributionId,
        );
        return contributionModel?.toEntity();
      },
      operationName: 'get contribution by ID',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (contribution) => contribution,
    );
  }

  @override
  Future<List<Contribution>> getContributionsByGroupId(int groupId) async {
    final result = await handleException(
      () async {
        final contributionModels = await _contributionDAO
            .getContributionsByGroupId(groupId);
        return contributionModels.map((model) => model.toEntity()).toList();
      },
      operationName: 'get contributions by group ID',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (contributions) => contributions,
    );
  }

  @override
  Future<List<Contribution>> getContributionsByMemberId(int memberId) async {
    final result = await handleException(
      () async {
        final contributionModels = await _contributionDAO
            .getContributionsByMemberId(memberId);
        return contributionModels.map((model) => model.toEntity()).toList();
      },
      operationName: 'get contributions by member ID',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (contributions) => contributions,
    );
  }

  @override
  Future<List<Contribution>> getPendingContributions(int groupId) async {
    final result = await handleException(
      () async {
        final contributionModels = await _contributionDAO
            .getPendingContributions(groupId);
        return contributionModels.map((model) => model.toEntity()).toList();
      },
      operationName: 'get pending contributions',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (contributions) => contributions,
    );
  }

  @override
  Future<List<Contribution>> getPaidContributions(int groupId) async {
    final result = await handleException(
      () async {
        final contributionModels = await _contributionDAO
            .getPaidContributions(groupId);
        return contributionModels.map((model) => model.toEntity()).toList();
      },
      operationName: 'get paid contributions',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (contributions) => contributions,
    );
  }

  @override
  Future<double> getTotalContributionsByGroup(int groupId) async {
    final result = await handleException(
      () => _contributionDAO.getTotalContributionsByGroup(groupId),
      operationName: 'get total contributions by group',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (total) => total,
    );
  }

  @override
  Future<double> getTotalContributionsByMember(int memberId) async {
    final result = await handleException(
      () => _contributionDAO.getTotalContributionsByMember(memberId),
      operationName: 'get total contributions by member',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (total) => total,
    );
  }
}
