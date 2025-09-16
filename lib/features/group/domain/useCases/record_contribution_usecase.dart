import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/contribution_entity.dart';
import '../repositories/contribution_repository.dart';

@injectable
class RecordContributionUseCase {
  final ContributionRepository repository;

  RecordContributionUseCase(this.repository);

  Future<Either<Failure, Contribution>> call(
    RecordContributionParams params,
  ) async {
    try {
      final contribution = Contribution(
        id: params.id,
        groupId: params.groupId,
        memberId: params.memberId,
        cycleId: params.cycleId,
        amount: params.amount,
        date: params.date ?? DateTime.now(),
        isPaid: params.isPaid,
        notes: params.notes,
      );

      final result = await repository.recordContribution(contribution);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class RecordContributionParams {
  final int id;
  final int groupId;
  final int memberId;
  final int cycleId;
  final double amount;
  final DateTime? date;
  final bool isPaid;
  final String? notes;

  RecordContributionParams({
    required this.id,
    required this.groupId,
    required this.memberId,
    required this.cycleId,
    required this.amount,
    this.date,
    this.isPaid = true,
    this.notes,
  });
}
