import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../home/domain/entities/recent_order_entity.dart';
import '../repositories/delivery_repository.dart';

class GetDeliveryHistoryUseCase
    implements UseCase<List<RecentOrderEntity>, GetDeliveryHistoryParams> {
  final DeliveryRepository repository;

  GetDeliveryHistoryUseCase(this.repository);

  @override
  Future<List<RecentOrderEntity>> call(GetDeliveryHistoryParams params) async {
    return await repository.getDeliveryHistory(params.userId);
  }
}

class GetDeliveryHistoryParams extends Equatable {
  final String userId;

  const GetDeliveryHistoryParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
