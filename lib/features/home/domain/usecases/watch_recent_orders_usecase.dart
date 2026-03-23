import 'package:equatable/equatable.dart';
import '../entities/recent_order_entity.dart';
import '../repositories/home_repository.dart';

class WatchRecentOrdersUseCase {
  final HomeRepository repository;

  WatchRecentOrdersUseCase(this.repository);

  Stream<List<RecentOrderEntity>> call(WatchRecentOrdersParams params) {
    return repository.watchRecentOrders(params.userId);
  }
}

class WatchRecentOrdersParams extends Equatable {
  final String userId;

  const WatchRecentOrdersParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
