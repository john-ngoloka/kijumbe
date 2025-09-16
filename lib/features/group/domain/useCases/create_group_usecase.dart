import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

@injectable
class CreateGroupUseCase {
  final GroupRepository repository;

  CreateGroupUseCase(this.repository);

  Future<Either<Failure, Group>> call(CreateGroupParams params) async {
    try {
      final group = Group(
        id: params.id,
        name: params.name,
        description: params.description,
        adminId: params.adminId,
        contributionAmount: params.contributionAmount,
        frequency: params.frequency,
        createdAt: DateTime.now(),
      );

      final result = await repository.createGroup(group);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class CreateGroupParams {
  final String id;
  final String name;
  final String description;
  final int adminId;
  final double contributionAmount;
  final String frequency;

  CreateGroupParams({
    required this.id,
    required this.name,
    required this.description,
    required this.adminId,
    required this.contributionAmount,
    required this.frequency,
  });
}
