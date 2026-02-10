import 'package:freezed_annotation/freezed_annotation.dart';

part 'break_slot_entity.freezed.dart';

@freezed
class BreakSlotEntity with _$BreakSlotEntity {
  const factory BreakSlotEntity({
    required DateTime startTime,
    required DateTime endTime,
    required int dayOfWeek,
    required String label,
    @Default(true) bool isActive,
  }) = _BreakSlotEntity;
}
