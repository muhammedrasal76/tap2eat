import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/delivery_repository.dart';

class RejectAssignmentUseCase
    implements UseCase<void, RejectAssignmentParams> {
  final DeliveryRepository repository;

  RejectAssignmentUseCase(this.repository);

  @override
  Future<void> call(RejectAssignmentParams params) async {
    return await repository.rejectAssignment(
      assignmentId: params.assignmentId,
      userId: params.userId,
    );
  }
}

class RejectAssignmentParams extends Equatable {
  final String assignmentId;
  final String userId;

  const RejectAssignmentParams({
    required this.assignmentId,
    required this.userId,
  });

  @override
  List<Object?> get props => [assignmentId, userId];
}
