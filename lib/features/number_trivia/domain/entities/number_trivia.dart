import 'package:equatable/equatable.dart';

//this a class that typify the data the number trivia will be working with.
//more like a model without the from and to json methods
//this is independent of the outside world
class NumberTrivia extends Equatable{
  final String text;
  final int number;

  const NumberTrivia({required this.text, required this.number});

  @override
  List<Object?> get props => [text, number];
}