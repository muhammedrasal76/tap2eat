// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'break_slot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BreakSlotModelImpl _$$BreakSlotModelImplFromJson(Map<String, dynamic> json) =>
    _$BreakSlotModelImpl(
      startTime: _timestampToDateTime(json['start_time'] as Timestamp),
      endTime: _timestampToDateTime(json['end_time'] as Timestamp),
      dayOfWeek: (json['day_of_week'] as num).toInt(),
      label: json['label'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$BreakSlotModelImplToJson(
  _$BreakSlotModelImpl instance,
) => <String, dynamic>{
  'start_time': _dateTimeToTimestamp(instance.startTime),
  'end_time': _dateTimeToTimestamp(instance.endTime),
  'day_of_week': instance.dayOfWeek,
  'label': instance.label,
  'is_active': instance.isActive,
};
