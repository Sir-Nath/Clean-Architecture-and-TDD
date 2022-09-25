import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/core/error/failure.dart';
import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/providers/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/providers/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}
class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp((){
    mockNetworkInfo = MockNetworkInfo();
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body){
    group('device is online', ()
    {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body){
    group('device is offline', ()
    {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', ()
  {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      //use thenReturn for synchronous operation
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      await repository.getConcreteNumberTrivia(tNumber);
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successful', () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });


      test(
          'should cache the data locally when the call to remote data source is successful', () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });


      test(
          'should return server failure when the call to remote data source is unsuccessful', () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test(
          'should return last locally cache data when the cache data is present',
              () async {
                when(mockLocalDataSource.getLastNumberTrivia())
                    .thenAnswer((_)async => tNumberTriviaModel);
                final result = await repository.getConcreteNumberTrivia(tNumber);
                verifyZeroInteractions(mockRemoteDataSource);
                verify(mockLocalDataSource.getLastNumberTrivia());
                expect(result, equals(Right(tNumberTrivia)));
          }
      );
      test(
          'should return cache failure when the cache data is not present',
              () async {
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            final result = await repository.getConcreteNumberTrivia(tNumber);
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          }
      );
    });
  });




  //test for random number trivia
  group('getRandomNumberTrivia', ()
  {
    final tNumberTriviaModel = NumberTriviaModel(number: 123, text: 'test');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      //use thenReturn for synchronous operation
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      await repository.getRandomNumberTrivia();
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successful', () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getRandomNumberTrivia();
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });


      test(
          'should cache the data locally when the call to remote data source is successful', () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getRandomNumberTrivia();
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });


      test(
          'should return server failure when the call to remote data source is unsuccessful', () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        final result = await repository.getRandomNumberTrivia();
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test(
          'should return last locally cache data when the cache data is present',
              () async {
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_)async => tNumberTriviaModel);
            final result = await repository.getRandomNumberTrivia();
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          }
      );
      test(
          'should return cache failure when the cache data is not present',
              () async {
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            final result = await repository.getRandomNumberTrivia();
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          }
      );
    });
  });
}
