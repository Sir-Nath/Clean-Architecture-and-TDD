import '../../domain/entities/number_trivia.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  ///Gets the cached [NumberTriviaModel] which was gotten the last time had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void>? cacheNumberTrivia(NumberTrivia? triviaToCache);
}