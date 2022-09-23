import '../../../../core/error/failure.dart';
import '../entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

//this is a contract that the concrete repository must obey i.e the repo in the data layer must conform to this
abstract class NumberTriviaRepository{
  //these methods are set to return either a NumberTrivia or a Failure
  //and from this contract every concrete implementation must have these two methods
  Future<Either<Failure, NumberTrivia?>>? getConcreteNumberTrivia(int? number);
  Future<Either<Failure, NumberTrivia>>? getRandomNumberTrivia();
}

