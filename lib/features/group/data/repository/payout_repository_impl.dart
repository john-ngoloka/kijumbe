import 'package:injectable/injectable.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../domain/entities/payout_entity.dart';
import '../../domain/repositories/payout_repository.dart';
import '../datasources/local/dao/payout_dao.dart';
import '../models/payout_model.dart';

@LazySingleton(as: PayoutRepository)
class PayoutRepositoryImpl extends BaseRepository implements PayoutRepository {
  final PayoutDAO _payoutDAO;

  PayoutRepositoryImpl(this._payoutDAO);

  @override
  Future<Payout> recordPayout(Payout payout) async {
    final result = await handleException(
      () async {
        final payoutModel = PayoutModel.fromEntity(payout);
        final recordedModel = await _payoutDAO.recordPayout(payoutModel);
        return recordedModel.toEntity();
      },
      operationName: 'record payout',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (payout) => payout,
    );
  }

  @override
  Future<Payout> updatePayout(Payout payout) async {
    final result = await handleException(
      () async {
        final payoutModel = PayoutModel.fromEntity(payout);
        final updatedModel = await _payoutDAO.updatePayout(payoutModel);
        return updatedModel.toEntity();
      },
      operationName: 'update payout',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (payout) => payout,
    );
  }

  @override
  Future<void> deletePayout(int payoutId) async {
    final result = await handleVoidException(
      () => _payoutDAO.deletePayout(payoutId),
      operationName: 'delete payout',
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => null,
    );
  }

  @override
  Future<Payout?> getPayoutById(int payoutId) async {
    final result = await handleException(
      () async {
        final payoutModel = await _payoutDAO.getPayoutById(payoutId);
        return payoutModel?.toEntity();
      },
      operationName: 'get payout by ID',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (payout) => payout,
    );
  }

  @override
  Future<List<Payout>> getPayoutsByGroupId(int groupId) async {
    final result = await handleException(
      () async {
        final payoutModels = await _payoutDAO.getPayoutsByGroupId(groupId);
        return payoutModels.map((model) => model.toEntity()).toList();
      },
      operationName: 'get payouts by group ID',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (payouts) => payouts,
    );
  }

  @override
  Future<List<Payout>> getPayoutsByMemberId(int memberId) async {
    final result = await handleException(
      () async {
        final payoutModels = await _payoutDAO.getPayoutsByMemberId(memberId);
        return payoutModels.map((model) => model.toEntity()).toList();
      },
      operationName: 'get payouts by member ID',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (payouts) => payouts,
    );
  }

  @override
  Future<List<Payout>> getPayoutsByCycle(int groupId, int cycleNumber) async {
    final result = await handleException(
      () async {
        final payoutModels = await _payoutDAO.getPayoutsByCycle(
          groupId,
          cycleNumber,
        );
        return payoutModels.map((model) => model.toEntity()).toList();
      },
      operationName: 'get payouts by cycle',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (payouts) => payouts,
    );
  }

  @override
  Future<double> getTotalPayoutsByGroup(int groupId) async {
    final result = await handleException(
      () => _payoutDAO.getTotalPayoutsByGroup(groupId),
      operationName: 'get total payouts by group',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (total) => total,
    );
  }

  @override
  Future<double> getTotalPayoutsByMember(int memberId) async {
    final result = await handleException(
      () => _payoutDAO.getTotalPayoutsByMember(memberId),
      operationName: 'get total payouts by member',
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (total) => total,
    );
  }
}
