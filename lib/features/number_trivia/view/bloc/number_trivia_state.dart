part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class Empty extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class Loading extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class Loaded extends NumberTriviaState {
  final NumberTrivia? trivia;
  const Loaded({required this.trivia});
  @override
  List<Object> get props => [trivia!];
}

class ErrorState extends NumberTriviaState {
  final String message;
  const ErrorState({required this.message});
  @override
  List<Object> get props => [message];
}