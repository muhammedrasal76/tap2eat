import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/delivery_repository.dart';

class UpdateDeliveryStatusUseCase
    implements UseCase<void, UpdateDeliveryStatusParams> {
  final DeliveryRepository repository;

  UpdateDeliveryStatusUseCase(this.repository);

  @override
  Future<void> call(UpdateDeliveryStatusParams params) async {
    return await repository.updateDeliveryStatus(
      orderId: params.orderId,
      status: params.status,
    );
  }
}

class UpdateDeliveryStatusParams extends Equatable {
  final String orderId;
  final String status;

  const UpdateDeliveryStatusParams({
    required this.orderId,
    required this.status,
  });

  @override
  List<Object?> get props => [orderId, status];
}
