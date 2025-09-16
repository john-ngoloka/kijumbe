import 'package:injectable/injectable.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../domain/entities/cycle_entity.dart';
import '../../domain/repositories/cycle_repository.dart';
import '../datasources/local/dao/cycle_dao.dart';
import '../models/cycle_model.dart';

@LazySingleton(as: CycleRepository)
class CycleRepositoryImpl extends BaseRepository implements CycleRepository {
  final CycleDAO _cycleDAO;

  CycleRepositoryImpl(this._cycleDAO);

  @override
  Future<Cycle> createCycle(Cycle cycle) async {
    final result = await handleException(() async {
      final cycleModel = CycleModel.fromEntity(cycle);
      final createdModel = await _cycleDAO.createCycle(cycleModel);
      return createdModel.toEntity();
    }, operationName: 'create cycle');

    return result.fold(
      (failure) => throw Exception(failure.message),
      (cycle) => cycle,
    );
  }

  @override
  Future<Cycle> updateCycle(Cycle cycle) async {
    final result = await handleException(() async {
      final cycleModel = CycleModel.fromEntity(cycle);
      final updatedModel = await _cycleDAO.updateCycle(cycleModel);
      return updatedModel.toEntity();
    }, operationName: 'update cycle');

    return result.fold(
      (failure) => throw Exception(failure.message),
      (cycle) => cycle,
    );
  }

  @override
  Future<void> deleteCycle(int cycleId) async {
    final result = await handleVoidException(
      () => _cycleDAO.deleteCycle(cycleId),
      operationName: 'delete cycle',
    );

    result.fold((failure) => throw Exception(failure.message), (_) => null);
  }

  @override
  Future<Cycle?> getCycleById(int cycleId) async {
    final result = await handleException(() async {
      final cycleModel = await _cycleDAO.getCycleById(cycleId);
      return cycleModel?.toEntity();
    }, operationName: 'get cycle by ID');

    return result.fold(
      (failure) => throw Exception(failure.message),
      (cycle) => cycle,
    );
  }

  @override
  Future<List<Cycle>> getCyclesByGroupId(int groupId) async {
    final result = await handleException(() async {
      final cycleModels = await _cycleDAO.getCyclesByGroupId(groupId);
      return cycleModels.map((model) => model.toEntity()).toList();
    }, operationName: 'get cycles by group ID');

    return result.fold(
      (failure) => throw Exception(failure.message),
      (cycles) => cycles,
    );
  }

  @override
  Future<Cycle?> getActiveCycleByGroupId(int groupId) async {
    final result = await handleException(() async {
      final cycleModel = await _cycleDAO.getActiveCycleByGroupId(groupId);
      return cycleModel?.toEntity();
    }, operationName: 'get active cycle by group ID');

    return result.fold(
      (failure) => throw Exception(failure.message),
      (cycle) => cycle,
    );
  }

  @override
  Future<List<Cycle>> getCompletedCyclesByGroupId(int groupId) async {
    final result = await handleException(() async {
      final cycleModels = await _cycleDAO.getCompletedCyclesByGroupId(groupId);
      return cycleModels.map((model) => model.toEntity()).toList();
    }, operationName: 'get completed cycles by group ID');

    return result.fold(
      (failure) => throw Exception(failure.message),
      (cycles) => cycles,
    );
  }

  @override
  Future<Cycle> startNewCycle(
    int groupId,
    int cycleNumber,
    double targetAmount,
    DateTime deadline,
  ) async {
    final result = await handleException(() async {
      final cycleModel = await _cycleDAO.startNewCycle(
        groupId,
        cycleNumber,
        targetAmount,
        deadline,
      );
      return cycleModel.toEntity();
    }, operationName: 'start new cycle');

    return result.fold(
      (failure) => throw Exception(failure.message),
      (cycle) => cycle,
    );
  }

  @override
  Future<Cycle> closeCycle(int cycleId) async {
    final result = await handleException(() async {
      final cycleModel = await _cycleDAO.closeCycle(cycleId);
      return cycleModel.toEntity();
    }, operationName: 'close cycle');

    return result.fold(
      (failure) => throw Exception(failure.message),
      (cycle) => cycle,
    );
  }
}
