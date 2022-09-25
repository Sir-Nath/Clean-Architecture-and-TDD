import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {
  @override
  Future<bool> get hasConnection async => super.noSuchMethod(
        Invocation.method(#hasConnection, []),
        returnValue: Future<bool>.value(false),
      );
}

void main() {
  late MockDataConnectionChecker mockDataConnectionChecker;
  late NetworkInfoImpl networkInfoImpl;
  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('is Connected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async {

      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);
      final result = await networkInfoImpl.isConnected;
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, true);
    });
  });
}
