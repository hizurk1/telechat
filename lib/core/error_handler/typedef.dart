import 'package:fpdart/fpdart.dart';

import 'error.dart';

typedef FutureEither<T> = Future<Either<Error, T>>;