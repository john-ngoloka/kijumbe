import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

typedef Result<T> = Either<Failure, T>;
typedef ResultVoid = Either<Failure, void>;
typedef ResultStream<T> = Stream<Either<Failure, T>>;
