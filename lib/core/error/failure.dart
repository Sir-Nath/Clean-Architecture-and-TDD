import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final List properties;
  const Failure({this.properties = const<dynamic>[],}): super();

  @override
  List<Object?> get props => [properties];
}


//General failures
class CacheException extends Failure{
}

class ServerException extends Failure{}