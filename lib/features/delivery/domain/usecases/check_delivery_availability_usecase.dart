import '../../../../core/usecase/usecase.dart';
import '../repositories/delivery_repository.dart';

class CheckDeliveryAvailabilityUseCase implements UseCase<bool, NoParams> {
  final DeliveryRepository repository;

  CheckDeliveryAvailabilityUseCase(this.repository);

  @override
  Future<bool> call(NoParams params) async {
    return await repository.hasAvailableDeliveryStudent();
  }
}
