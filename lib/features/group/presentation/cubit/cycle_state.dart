part of 'cycle_cubit.dart';

abstract class CycleState extends Equatable {
  const CycleState();

  @override
  List<Object?> get props => [];
}

class CycleInitial extends CycleState {}

class CycleLoading extends CycleState {}

class CycleLoaded extends CycleState {
  final Cycle cycle;

  const CycleLoaded(this.cycle);

  @override
  List<Object?> get props => [cycle];
}

class CycleNoActive extends CycleState {}

class CycleStarted extends CycleState {
  final Cycle cycle;

  const CycleStarted(this.cycle);

  @override
  List<Object?> get props => [cycle];
}

class CycleCompleted extends CycleState {
  final CycleCompletionResult result;

  const CycleCompleted(this.result);

  @override
  List<Object?> get props => [result];
}

class ContributionRecorded extends CycleState {
  final Contribution contribution;

  const ContributionRecorded(this.contribution);

  @override
  List<Object?> get props => [contribution];
}

class CycleContributionsLoaded extends CycleState {
  final List<Contribution> contributions;

  const CycleContributionsLoaded(this.contributions);

  @override
  List<Object?> get props => [contributions];
}

class CycleError extends CycleState {
  final String message;

  const CycleError(this.message);

  @override
  List<Object?> get props => [message];
}
