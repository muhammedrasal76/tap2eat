// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsModelImpl _$$SettingsModelImplFromJson(Map<String, dynamic> json) =>
    _$SettingsModelImpl(
      breakSlots: _timestampListToDateTime(json['break_slots'] as List),
      orderCutoffMinutes: (json['order_cutoff_minutes'] as num).toInt(),
    );

Map<String, dynamic> _$$SettingsModelImplToJson(_$SettingsModelImpl instance) =>
    <String, dynamic>{
      'break_slots': _dateTimeListToTimestamp(instance.breakSlots),
      'order_cutoff_minutes': instance.orderCutoffMinutes,
    };
