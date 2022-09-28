import 'dart:convert';
import 'dart:math';

import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/providers/number_trivia_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;


class MockHttpClient extends Mock implements http.Client{
  @override
  Future<Response> get(Uri? url, {Map<String, String>? headers}){
    return super.noSuchMethod(
        Invocation.method(#get, [url, headers]),
        returnValue: Future<Response>.value(Response(fixture('trivia.json'), 200))
    );
  }
}

void main(){
  late NumberTriviaRemoteDataSource dataSource;
  late MockHttpClient mockHttpClient;

  setUp((){
    mockHttpClient = MockHttpClient();
  dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200(){
    when(mockHttpClient.get(any, headers: {'Content-Type': 'application/json'}))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }
  void setUpMockHttpClientFailure400(){
    when(mockHttpClient.get(any, headers: {'Content-Type': 'application/json'}))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('get random number trivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('should perform a get request on a URL with number being the end point and with application/json header', ()async {
    setUpMockHttpClientSuccess200();
      dataSource.getRandomNumberTrivia();
      verify(mockHttpClient.get(Uri.parse('http://numbersapi.com/random'), headers: {'Content-Type': 'application/json'}));
    });
    test('should return number trivia when the respond code is 200', () async {
      setUpMockHttpClientSuccess200();
      final result = await dataSource.getRandomNumberTrivia();
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a server exception when the response code is 404 or other ', ()async{
     setUpMockHttpClientFailure400();
      final call = dataSource.getRandomNumberTrivia;
      expect(()=> call(), throwsA(TypeMatcher<ServerException>()));
    });
  });


  group('get concrete number trivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('should perform a get request on a URL with number being the end point and with application/json header', ()async {
      setUpMockHttpClientSuccess200();
      dataSource.getConcreteNumberTrivia(tNumber);
      verify(mockHttpClient.get(Uri.parse('http://numbersapi.com/$tNumber'), headers: {'Content-Type': 'application/json'}));
    });
    test('should return number trivia when the respond code is 200', () async {
      setUpMockHttpClientSuccess200();
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a server exception when the response code is 404 or other ', ()async{
      setUpMockHttpClientFailure400();
      final call = dataSource.getConcreteNumberTrivia;
      expect(()=> call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

}
