import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../home/domain/entities/recent_order_entity.dart';
import '../repositories/order_repository.dart';

/// Use case to create a new order
class CreateOrderUseCase implements UseCase<String, CreateOrderParams> {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<String> call(CreateOrderParams params) async {
    return await repository.createOrder(
      canteenId: params.canteenId,
      canteenName: params.canteenName,
      userId: params.userId,
      items: params.items,
      totalAmount: params.totalAmount,
      fulfillmentSlot: params.fulfillmentSlot,
      fulfillmentType: params.fulfillmentType,
      deliveryFee: params.deliveryFee,
    );
  }
}

class CreateOrderParams extends Equatable {
  final String canteenId;
  final String canteenName;
  final String userId;
  final List<OrderItemEntity> items;
  final double totalAmount;
  final DateTime fulfillmentSlot;
  final String fulfillmentType;
  final double deliveryFee;

  const CreateOrderParams({
    required this.canteenId,
    required this.canteenName,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.fulfillmentSlot,
    required this.fulfillmentType,
    required this.deliveryFee,
  });

  @override
  List<Object?> get props => [
        canteenId,
        canteenName,
        userId,
        items,
        totalAmount,
        fulfillmentSlot,
        fulfillmentType,
        deliveryFee,
      ];
}
