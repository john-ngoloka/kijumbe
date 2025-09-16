import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

@injectable
class SearchGroupsUseCase {
  final GroupRepository repository;

  SearchGroupsUseCase(this.repository);

  Future<Either<Failure, List<Group>>> call(String query) async {
    try {
      final result = await repository.searchGroups(query);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
