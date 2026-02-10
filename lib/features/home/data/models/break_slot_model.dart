import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/break_slot_entity.dart';

part 'break_slot_model.freezed.dart';
part 'break_slot_model.g.dart';

DateTime _timestampToDateTime(Timestamp timestamp) => timestamp.toDate();
Timestamp _dateTimeToTimestamp(DateTime dateTime) =>
    Timestamp.fromDate(dateTime);

@freezed
class BreakSlotModel with _$BreakSlotModel {
  const BreakSlotModel._();

  const factory BreakSlotModel({
    @JsonKey(
      name: 'start_time',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    required DateTime startTime,
    @JsonKey(
      name: 'end_time',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    required DateTime endTime,
    @JsonKey(name: 'day_of_week') required int dayOfWeek,
    required String label,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _BreakSlotModel;

  factory BreakSlotModel.fromJson(Map<String, dynamic> json) =>
      _$BreakSlotModelFromJson(json);

  BreakSlotEntity toEntity() {
    return BreakSlotEntity(
      startTime: startTime,
      endTime: endTime,
      dayOfWeek: dayOfWeek,
      label: label,
      isActive: isActive,
    );
  }
}
