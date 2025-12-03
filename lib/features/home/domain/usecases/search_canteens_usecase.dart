import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/canteen_entity.dart';
import '../repositories/home_repository.dart';

/// Use case to search canteens by query
class SearchCanteensUseCase
    implements UseCase<List<CanteenEntity>, SearchCanteensParams> {
  final HomeRepository repository;

  SearchCanteensUseCase(this.repository);

  @override
  Future<List<CanteenEntity>> call(SearchCanteensParams params) async {
    return await repository.searchCanteens(params.query);
  }
}

class SearchCanteensParams extends Equatable {
  final String query;

  const SearchCanteensParams({required this.query});

  @override
  List<Object?> get props => [query];
}
