import 'package:dartz/dartz.dart';
import 'package:new_udemy_course/core/error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
