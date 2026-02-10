import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../home/domain/entities/recent_order_entity.dart';
import '../repositories/order_repository.dart';

/// Use case to fetch a single order detail
class GetOrderDetailUseCase
    implements UseCase<RecentOrderEntity, GetOrderDetailParams> {
  final OrderRepository repository;

  GetOrderDetailUseCase(this.repository);

  @override
  Future<RecentOrderEntity> call(GetOrderDetailParams params) async {
    return await repository.getOrderDetail(params.orderId);
  }
}

class GetOrderDetailParams extends Equatable {
  final String orderId;

  const GetOrderDetailParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
