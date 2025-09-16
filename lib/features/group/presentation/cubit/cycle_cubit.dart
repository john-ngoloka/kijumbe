import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/cycle_entity.dart';
import '../../domain/entities/contribution_entity.dart';
import '../../domain/useCases/start_new_cycle_usecase.dart';
import '../../domain/useCases/process_cycle_completion_usecase.dart';
import '../../domain/useCases/get_active_cycle_usecase.dart';
import '../../domain/useCases/record_contribution_usecase.dart';
import '../../domain/useCases/get_contributions_by_group_usecase.dart';

part 'cycle_state.dart';

@injectable
class CycleCubit extends Cubit<CycleState> {
  final StartNewCycleUseCase _startNewCycleUseCase;
  final ProcessCycleCompletionUseCase _processCycleCompletionUseCase;
  final GetActiveCycleUseCase _getActiveCycleUseCase;
  final RecordContributionUseCase _recordContributionUseCase;
  final GetContributionsByGroupUseCase _getContributionsByGroupUseCase;

  CycleCubit(
    this._startNewCycleUseCase,
    this._processCycleCompletionUseCase,
    this._getActiveCycleUseCase,
    this._recordContributionUseCase,
    this._getContributionsByGroupUseCase,
  ) : super(CycleInitial());

  Future<void> startNewCycle({
    required int groupId,
    required double targetAmount,
    required DateTime deadline,
  }) async {
    emit(CycleLoading());

    try {
      // Get next cycle number
      final nextCycleNumber = await _getNextCycleNumber(groupId);

      final result = await _startNewCycleUseCase(
        StartNewCycleParams(
          id: DateTime.now().millisecondsSinceEpoch,
          groupId: groupId,
          cycleNumber: nextCycleNumber,
          targetAmount: targetAmount,
          deadline: deadline,
        ),
      );

      result.fold(
        (failure) => emit(CycleError(failure.message)),
        (cycle) => emit(CycleStarted(cycle)),
      );
    } catch (e) {
      emit(CycleError(e.toString()));
    }
  }

  Future<void> getActiveCycle(int groupId) async {
    emit(CycleLoading());

    final result = await _getActiveCycleUseCase(groupId);

    result.fold((failure) => emit(CycleError(failure.message)), (cycle) {
      if (cycle != null) {
        emit(CycleLoaded(cycle));
      } else {
        emit(CycleNoActive());
      }
    });
  }

  Future<void> recordContribution({
    required int groupId,
    required int memberId,
    required int cycleId,
    required double amount,
    String? notes,
  }) async {
    emit(CycleLoading());

    final result = await _recordContributionUseCase(
      RecordContributionParams(
        id: DateTime.now().millisecondsSinceEpoch,
        groupId: groupId,
        memberId: memberId,
        cycleId: cycleId,
        amount: amount,
        isPaid: true,
        notes: notes,
      ),
    );

    result.fold(
      (failure) => emit(CycleError(failure.message)),
      (contribution) => emit(ContributionRecorded(contribution)),
    );
  }

  Future<void> completeCycle(int groupId) async {
    emit(CycleLoading());

    final result = await _processCycleCompletionUseCase(groupId);

    result.fold(
      (failure) => emit(CycleError(failure.message)),
      (completionResult) => emit(CycleCompleted(completionResult)),
    );
  }

  Future<void> getCycleContributions(int groupId, int cycleId) async {
    emit(CycleLoading());

    final result = await _getContributionsByGroupUseCase(groupId);

    result.fold((failure) => emit(CycleError(failure.message)), (
      contributions,
    ) {
      final cycleContributions = contributions
          .where((c) => c.cycleId == cycleId)
          .toList();
      emit(CycleContributionsLoaded(cycleContributions));
    });
  }

  Future<int> _getNextCycleNumber(int groupId) async {
    // Simple approach for now - in a real app, this would come from a repository
    return DateTime.now().millisecondsSinceEpoch % 1000;
  }
}
