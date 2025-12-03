import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_entity.freezed.dart';

@freezed
class SettingsEntity with _$SettingsEntity {
  const factory SettingsEntity({
    required List<DateTime> breakSlots,
    required int orderCutoffMinutes,
  }) = _SettingsEntity;
}
