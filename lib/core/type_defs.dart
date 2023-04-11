import 'package:fpdart/fpdart.dart';

import 'failure.dart';

typedef FutureEtheir<T> = Future<Either<Failure, T>>;
typedef FutureEtheirVoid = FutureEtheir<void>;
typedef FutureVoid = Future<void>;
