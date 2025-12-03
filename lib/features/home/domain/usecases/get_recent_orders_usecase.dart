import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/recent_order_entity.dart';
import '../repositories/home_repository.dart';

/// Use case to fetch recent orders for a user
class GetRecentOrdersUseCase
    implements UseCase<List<RecentOrderEntity>, GetRecentOrdersParams> {
  final HomeRepository repository;

  GetRecentOrdersUseCase(this.repository);

  @override
  Future<List<RecentOrderEntity>> call(GetRecentOrdersParams params) async {
    return await repository.getRecentOrders(params.userId);
  }
}

class GetRecentOrdersParams extends Equatable {
  final String userId;

  const GetRecentOrdersParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
