import 'dart:ffi';

import 'package:fpdart/fpdart.dart';
import 'package:appwrite/appwrite.dart';

import 'failure.dart';

typedef FutureEtheir<T> = Future<Either<Failure, T>>;
typedef FutureEtheirVoid = FutureEtheir<void>;
typedef FutureVoid = Future<void>;
