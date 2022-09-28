import 'package:clean_architecture_tdd_course/core/error/failure.dart';
import 'package:clean_architecture_tdd_course/core/util/input_converter.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/view/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {
  // @override
  // Either<Failure, int> stringToUnsignedInteger(String? str){
  //   super.noSuchMethod(
  //       Invocation.method(#stringToUnsunedInteger, [str]),
  //       returnValue: 1
  //   );
  //   return const Right(1);
  // }
}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    bloc = NumberTriviaBloc(
      inputConverter: mockInputConverter,
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
    );
  });

  test('initial state should be empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('get trivia for concrete number', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger('1'))
          .thenReturn(Right(tNumberParsed));
    }

    test(
        'should call the input converter to validate and convert the string to an unsigned integer',
        () async {
      setUpMockInputConverterSuccess();
      bloc.onEvent(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger('1'));
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () {
      when(mockInputConverter.stringToUnsignedInteger('1'))
          .thenReturn(Left(InvalidInputFailure()));
      final expected = [
        Empty(),
        ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      bloc.onEvent(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get concrete data from the use case', () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      bloc.onEvent(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully]',(){
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      final expected = [Empty(),Loading(),Loaded(trivia: tNumberTrivia),];
      expectLater(bloc.state, emitsInOrder(expected));
      bloc.onEvent(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] when getting data failure]',(){
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      final expected = [Empty(),Loading(),const ErrorState(message: SERVER_FAILURE_MESSAGE),];
      expectLater(bloc.state, emitsInOrder(expected));
      bloc.onEvent(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] with proper message for the error when getting data fails]',(){
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [Empty(),Loading(),const ErrorState(message: CACHE_FAILURE_MESSAGE),];
      expectLater(bloc.state, emitsInOrder(expected));
      bloc.onEvent(GetTriviaForConcreteNumber(tNumberString));
    });


  });
}
