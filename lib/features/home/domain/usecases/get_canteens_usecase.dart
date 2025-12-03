import '../../../../core/usecase/usecase.dart';
import '../entities/canteen_entity.dart';
import '../repositories/home_repository.dart';

/// Use case to fetch all active canteens
class GetCanteensUseCase implements UseCase<List<CanteenEntity>, NoParams> {
  final HomeRepository repository;

  GetCanteensUseCase(this.repository);

  @override
  Future<List<CanteenEntity>> call(NoParams params) async {
    return await repository.getCanteens();
  }
}
