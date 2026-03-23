import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/recent_order_entity.dart';
import '../repositories/order_repository.dart';

class WatchOrderHistoryUseCase {
  final OrderRepository repository;

  WatchOrderHistoryUseCase(this.repository);

  Stream<List<RecentOrderEntity>> call(WatchOrderHistoryParams params) {
    return repository.watchOrderHistory(params.userId);
  }
}

class WatchOrderHistoryParams extends Equatable {
  final String userId;

  const WatchOrderHistoryParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
