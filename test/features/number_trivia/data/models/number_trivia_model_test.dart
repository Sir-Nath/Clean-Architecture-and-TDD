import 'dart:convert';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../fixtures/fixture_reader.dart';

void main(){
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test');
  test('should be a subclass of NumberTrivia entity', ()async{
    //isA keyword check if the expected is of the same type as the actual
    expect(tNumberTriviaModel, isA<NumberTriviaModel>());
  });

  group('fromJson', () {
    test('should return a valid model when json number is an integer',
        ()async{
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));
        final result = NumberTriviaModel.fromJson(jsonMap);
        //equals compares directly and ensure they are the same
        expect(result, equals(tNumberTriviaModel));
        }
    );
    test('should return a valid model when json number is regarded as a double',
            ()async{
          final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
          final result = NumberTriviaModel.fromJson(jsonMap);
          //equals compares directly and ensure they are the same
          expect(result, equals(tNumberTriviaModel));
        }
    );
  });
  group('toJson', () {
    test('should return a Json map containing the proper data',()async{
      final result = tNumberTriviaModel.toJson();
      final expectedMap = {
        "text": "test",
        "number": 1,
      };
      expect(result, expectedMap);
    });
  });
}