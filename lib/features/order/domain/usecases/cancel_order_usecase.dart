import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/order_repository.dart';

/// Use case to cancel a pending order
class CancelOrderUseCase implements UseCase<void, CancelOrderParams> {
  final OrderRepository repository;

  CancelOrderUseCase(this.repository);

  @override
  Future<void> call(CancelOrderParams params) async {
    return await repository.cancelOrder(params.orderId);
  }
}

class CancelOrderParams extends Equatable {
  final String orderId;

  const CancelOrderParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
