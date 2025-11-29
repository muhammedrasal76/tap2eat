import 'package:equatable/equatable.dart';

/// Base class for all use cases
/// Type Parameters:
/// - Type: The return type of the use case
/// - Params: The parameters required by the use case
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Use case that doesn't require parameters
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
