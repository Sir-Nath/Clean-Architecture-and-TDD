import 'dart:developer';

import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:clean_architecture_tdd_course/core/util/input_converter.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/providers/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/providers/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/view/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/number_trivia/domain/repositories/number_repository.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async{
  log('hi 2');
  //Features - Number Trivia
  //Bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      inputConverter: sl(),
      concrete: sl(),
      random: sl(),
    ),
  );
  //uses cases
  log('hi 3');
  sl.registerLazySingleton(
    () => GetConcreteNumberTrivia(
      repository: sl(),
    ),
  );
  log('hi 4');
  sl.registerLazySingleton(
    () => GetRandomNumberTrivia(
      sl(),
    ),
  );
  log('hi 5');
  //repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  log('hi 6');
  //Data souces
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      client: sl(),
    ),
  );
  log('hi 7');
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );
  log('hi 8');
  //Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      sl(),
    ),
  );
  //External
  log('hi9');
  final sharePreferences = await SharedPreferences.getInstance();
  log('hi 10');
  sl.registerLazySingleton(()  => sharePreferences);
  log('hi 10');
  sl.registerLazySingleton(() => http.Client());
  log('hi 10');
  sl.registerLazySingleton(() => DataConnectionChecker());
  log('hi 10');
}
