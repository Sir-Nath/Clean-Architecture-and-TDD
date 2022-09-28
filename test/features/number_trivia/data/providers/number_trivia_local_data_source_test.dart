import 'dart:convert';
import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/providers/number_trivia_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'package:mockito/mockito.dart';
// import 'package:mocktail/mocktail.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {
  @override
  String? getString(String? key) => super.noSuchMethod(
    Invocation.method(#getString, [key]),
    returnValue: ''
  );

  @override
  Future<bool> setString(String? key, String? value) => super.noSuchMethod(
    Invocation.method(#setString, [key, value]),
    returnValue: Future<bool>.value(true),
  );
}

void main(){
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('get last number trivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test('should return number trivia from shared preference when there is one in the cached', () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await dataSource.getLastNumberTrivia();

      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result,equals(tNumberTriviaModel));

    });
    test('should throw cache exception when there is not a cache value', () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(null);
      //final Future<NumberTriviaModel>? call = dataSource.getLastNumberTrivia();
    expect(()=> dataSource.getLastNumberTrivia(), throwsA(const TypeMatcher<CacheException>()));

    });
  });
group('cache Number trivia', () {
  final tNumberTriviaModel = NumberTriviaModel(text: 'test', number: 1);
  test('should call shared preference to cache the data', ()async{
    when(mockSharedPreferences.setString(any,any)).thenAnswer((_)async => true);
    dataSource.cacheNumberTrivia(tNumberTriviaModel);
    final exceptedJsonString = json.encode(tNumberTriviaModel.toJson());
    verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA,exceptedJsonString));
  });
});
}
