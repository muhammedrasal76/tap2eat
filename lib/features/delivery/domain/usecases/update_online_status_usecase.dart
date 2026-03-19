import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/delivery_repository.dart';

class UpdateOnlineStatusUseCase
    implements UseCase<void, UpdateOnlineStatusParams> {
  final DeliveryRepository repository;

  UpdateOnlineStatusUseCase(this.repository);

  @override
  Future<void> call(UpdateOnlineStatusParams params) async {
    return await repository.updateOnlineStatus(
      userId: params.userId,
      isOnline: params.isOnline,
    );
  }
}

class UpdateOnlineStatusParams extends Equatable {
  final String userId;
  final bool isOnline;

  const UpdateOnlineStatusParams({
    required this.userId,
    required this.isOnline,
  });

  @override
  List<Object?> get props => [userId, isOnline];
}
