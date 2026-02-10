import 'package:freezed_annotation/freezed_annotation.dart';
import 'break_slot_entity.dart';

part 'settings_entity.freezed.dart';

@freezed
class SettingsEntity with _$SettingsEntity {
  const factory SettingsEntity({
    required List<BreakSlotEntity> breakSlots,
    required int orderCutoffMinutes,
  }) = _SettingsEntity;
}
