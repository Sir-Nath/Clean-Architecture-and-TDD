import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:clean_architecture_tdd_course/core/error/failure.dart';
import 'package:clean_architecture_tdd_course/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/util/input_converter.dart';
import '../../data/models/number_trivia_model.dart';
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

    on<GetTriviaForConcreteNumber>((event, emit) async {
      emit(Loading());
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      await inputEither!.fold((failure) async{
        emit(const ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE));
      }, (integer) async {
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        failureOrTrivia!.fold(
            (failure){
              emit(ErrorState(message: _mapFailureToMessage(failure)));
            },
            (trivia) {
              emit(Loaded(trivia: trivia));
        });
      });

    });

    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(Loading());
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      failureOrTrivia!.fold(
              (failure){
            emit(ErrorState(message: _mapFailureToMessage(failure)));
          },
              (trivia) {
            emit(Loaded(trivia: trivia));
          });
      });

  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia?> failureOrTrivia) async* {
    yield* failureOrTrivia.fold((failure) {
      throw ErrorState(message: _mapFailureToMessage(failure));
    }, (trivia) async* {
      yield Loaded(trivia: trivia!);
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
