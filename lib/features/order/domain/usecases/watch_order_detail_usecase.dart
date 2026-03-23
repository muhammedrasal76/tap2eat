import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/recent_order_entity.dart';
import '../repositories/order_repository.dart';

class WatchOrderDetailUseCase {
  final OrderRepository repository;

  WatchOrderDetailUseCase(this.repository);

  Stream<RecentOrderEntity?> call(WatchOrderDetailParams params) {
    return repository.watchOrderDetail(params.orderId);
  }
}

class WatchOrderDetailParams extends Equatable {
  final String orderId;

  const WatchOrderDetailParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
