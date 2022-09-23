import 'package:clean_architecture_tdd_course/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/repositories/number_repository.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main(){
  late GetRandomNumberTrivia useCase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });
  final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia from the repository', ()async{

    when(mockNumberTriviaRepository.getRandomNumberTrivia()).thenAnswer((_)async => Right(tNumberTrivia));

    final result = await useCase(NoParams());

    expect(result, Right(tNumberTrivia));

    verify(mockNumberTriviaRepository.getRandomNumberTrivia());

    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}