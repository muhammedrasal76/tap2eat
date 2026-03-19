import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/order_repository.dart';

/// Use case to fetch the active order count for a canteen
class GetActiveOrderCountUseCase
    implements UseCase<int, GetActiveOrderCountParams> {
  final OrderRepository repository;

  GetActiveOrderCountUseCase(this.repository);

  @override
  Future<int> call(GetActiveOrderCountParams params) async {
    return await repository.getActiveOrderCount(params.canteenId);
  }
}

class GetActiveOrderCountParams extends Equatable {
  final String canteenId;

  const GetActiveOrderCountParams({required this.canteenId});

  @override
  List<Object?> get props => [canteenId];
}
