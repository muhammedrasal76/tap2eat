import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/delivery_repository.dart';

class AcceptAssignmentUseCase
    implements UseCase<String, AcceptAssignmentParams> {
  final DeliveryRepository repository;

  AcceptAssignmentUseCase(this.repository);

  @override
  Future<String> call(AcceptAssignmentParams params) async {
    return await repository.acceptAssignment(
      assignmentId: params.assignmentId,
      orderId: params.orderId,
      userId: params.userId,
    );
  }
}

class AcceptAssignmentParams extends Equatable {
  final String assignmentId;
  final String orderId;
  final String userId;

  const AcceptAssignmentParams({
    required this.assignmentId,
    required this.orderId,
    required this.userId,
  });

  @override
  List<Object?> get props => [assignmentId, orderId, userId];
}
