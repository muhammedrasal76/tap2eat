import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/settings_entity.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

// Converter functions for Timestamp List <-> DateTime List
List<DateTime> _timestampListToDateTime(List<dynamic> timestamps) {
  return timestamps
      .map((ts) => ts is Timestamp ? ts.toDate() : DateTime.now())
      .toList();
}

List<Timestamp> _dateTimeListToTimestamp(List<DateTime> dateTimes) {
  return dateTimes.map((dt) => Timestamp.fromDate(dt)).toList();
}

@freezed
class SettingsModel with _$SettingsModel {
  const SettingsModel._();

  const factory SettingsModel({
    @JsonKey(
      name: 'break_slots',
      fromJson: _timestampListToDateTime,
      toJson: _dateTimeListToTimestamp,
    )
    required List<DateTime> breakSlots,
    @JsonKey(name: 'order_cutoff_minutes') required int orderCutoffMinutes,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  /// Convert to domain entity
  SettingsEntity toEntity() {
    return SettingsEntity(
      breakSlots: breakSlots,
      orderCutoffMinutes: orderCutoffMinutes,
    );
  }
}
