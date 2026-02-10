import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../home/domain/entities/recent_order_entity.dart';
import '../repositories/order_repository.dart';

/// Use case to fetch order history for a user
class GetOrderHistoryUseCase
    implements UseCase<List<RecentOrderEntity>, GetOrderHistoryParams> {
  final OrderRepository repository;

  GetOrderHistoryUseCase(this.repository);

  @override
  Future<List<RecentOrderEntity>> call(GetOrderHistoryParams params) async {
    return await repository.getOrderHistory(params.userId);
  }
}

class GetOrderHistoryParams extends Equatable {
  final String userId;

  const GetOrderHistoryParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
