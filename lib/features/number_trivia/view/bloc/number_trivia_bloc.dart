import 'package:bloc/bloc.dart';
import 'package:clean_architecture_tdd_course/core/error/failure.dart';
import 'package:clean_architecture_tdd_course/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_trivia.dart';
part 'number_trivia_event.dart';
part 'number_trivia_state.dart';


const String SERVER_FAILURE_MESSAGE = 'Server failure';
const String CACHE_FAILURE_MESSAGE = 'Cache failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input';


class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.inputConverter,
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
  })  : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(Empty()) {
    @override
    Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
      if (event is GetTriviaForConcreteNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);
        yield* inputEither!.fold((failure) async* {
          yield const ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE);
        }, (integer) async* {
          yield Loading();
          final failureOrTrivia =
              await getConcreteNumberTrivia(Params(number: integer));
          yield* _eitherLoadedOrErrorState(failureOrTrivia!);
        });
      }else if(event is GetTriviaForRandomNumber){
        yield Loading();
        final failureOrTrivia =
        await getRandomNumberTrivia(NoParams());
        yield* _eitherLoadedOrErrorState(failureOrTrivia!);
      }
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(Either<Failure, NumberTrivia?> failureOrTrivia) async*{
     yield* failureOrTrivia.fold((failure) {
      throw ErrorState(
          message: _mapFailureToMessage(failure)
      );
    }, (trivia) async* {
      yield Loaded(trivia: trivia!);
    });
  }

  String _mapFailureToMessage(Failure failure){
    switch(failure.runtimeType){
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
