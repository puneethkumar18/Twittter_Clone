import 'package:fpdart/fpdart.dart';
import 'core.dart';

typedef FutureEither<T> = Future<Either<Failure,T>>;
typedef FutureEithervoid = FutureEither<void>;