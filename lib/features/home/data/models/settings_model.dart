import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/settings_entity.dart';
import 'break_slot_model.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

List<BreakSlotModel> _breakSlotsFromJson(List<dynamic> json) {
  return json
      .map((item) =>
          BreakSlotModel.fromJson(Map<String, dynamic>.from(item as Map)))
      .toList();
}

List<Map<String, dynamic>> _breakSlotsToJson(List<BreakSlotModel> slots) {
  return slots.map((slot) => slot.toJson()).toList();
}

@freezed
class SettingsModel with _$SettingsModel {
  const SettingsModel._();

  const factory SettingsModel({
    @JsonKey(
      name: 'break_slots',
      fromJson: _breakSlotsFromJson,
      toJson: _breakSlotsToJson,
    )
    required List<BreakSlotModel> breakSlots,
    @JsonKey(name: 'order_cutoff_minutes') required int orderCutoffMinutes,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  /// Convert to domain entity
  SettingsEntity toEntity() {
    return SettingsEntity(
      breakSlots: breakSlots.map((slot) => slot.toEntity()).toList(),
      orderCutoffMinutes: orderCutoffMinutes,
    );
  }
}
