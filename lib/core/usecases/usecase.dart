import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failure.dart';

//these a contract or abstraction every use case should follow
abstract class UseCase<Type, Params>{
  Future<Either<Failure, Type?>?>? call(Params params);
}

class NoParams extends Equatable{
  @override
  List<Object?> get props => [];
}
