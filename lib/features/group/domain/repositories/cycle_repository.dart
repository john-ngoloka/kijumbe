import '../entities/cycle_entity.dart';

abstract class CycleRepository {
  Future<Cycle> createCycle(Cycle cycle);
  Future<Cycle> updateCycle(Cycle cycle);
  Future<void> deleteCycle(int cycleId);
  Future<Cycle?> getCycleById(int cycleId);
  Future<List<Cycle>> getCyclesByGroupId(int groupId);
  Future<Cycle?> getActiveCycleByGroupId(int groupId);
  Future<List<Cycle>> getCompletedCyclesByGroupId(int groupId);
  Future<Cycle> startNewCycle(
    int groupId,
    int cycleNumber,
    double targetAmount,
    DateTime deadline,
  );
  Future<Cycle> closeCycle(int cycleId);
}
