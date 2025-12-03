// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) {
  return _SettingsModel.fromJson(json);
}

/// @nodoc
mixin _$SettingsModel {
  @JsonKey(
    name: 'break_slots',
    fromJson: _timestampListToDateTime,
    toJson: _dateTimeListToTimestamp,
  )
  List<DateTime> get breakSlots => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_cutoff_minutes')
  int get orderCutoffMinutes => throw _privateConstructorUsedError;

  /// Serializes this SettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingsModelCopyWith<SettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsModelCopyWith<$Res> {
  factory $SettingsModelCopyWith(
    SettingsModel value,
    $Res Function(SettingsModel) then,
  ) = _$SettingsModelCopyWithImpl<$Res, SettingsModel>;
  @useResult
  $Res call({
    @JsonKey(
      name: 'break_slots',
      fromJson: _timestampListToDateTime,
      toJson: _dateTimeListToTimestamp,
    )
    List<DateTime> breakSlots,
    @JsonKey(name: 'order_cutoff_minutes') int orderCutoffMinutes,
  });
}

/// @nodoc
class _$SettingsModelCopyWithImpl<$Res, $Val extends SettingsModel>
    implements $SettingsModelCopyWith<$Res> {
  _$SettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? breakSlots = null, Object? orderCutoffMinutes = null}) {
    return _then(
      _value.copyWith(
            breakSlots: null == breakSlots
                ? _value.breakSlots
                : breakSlots // ignore: cast_nullable_to_non_nullable
                      as List<DateTime>,
            orderCutoffMinutes: null == orderCutoffMinutes
                ? _value.orderCutoffMinutes
                : orderCutoffMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SettingsModelImplCopyWith<$Res>
    implements $SettingsModelCopyWith<$Res> {
  factory _$$SettingsModelImplCopyWith(
    _$SettingsModelImpl value,
    $Res Function(_$SettingsModelImpl) then,
  ) = __$$SettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(
      name: 'break_slots',
      fromJson: _timestampListToDateTime,
      toJson: _dateTimeListToTimestamp,
    )
    List<DateTime> breakSlots,
    @JsonKey(name: 'order_cutoff_minutes') int orderCutoffMinutes,
  });
}

/// @nodoc
class __$$SettingsModelImplCopyWithImpl<$Res>
    extends _$SettingsModelCopyWithImpl<$Res, _$SettingsModelImpl>
    implements _$$SettingsModelImplCopyWith<$Res> {
  __$$SettingsModelImplCopyWithImpl(
    _$SettingsModelImpl _value,
    $Res Function(_$SettingsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? breakSlots = null, Object? orderCutoffMinutes = null}) {
    return _then(
      _$SettingsModelImpl(
        breakSlots: null == breakSlots
            ? _value._breakSlots
            : breakSlots // ignore: cast_nullable_to_non_nullable
                  as List<DateTime>,
        orderCutoffMinutes: null == orderCutoffMinutes
            ? _value.orderCutoffMinutes
            : orderCutoffMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SettingsModelImpl extends _SettingsModel {
  const _$SettingsModelImpl({
    @JsonKey(
      name: 'break_slots',
      fromJson: _timestampListToDateTime,
      toJson: _dateTimeListToTimestamp,
    )
    required final List<DateTime> breakSlots,
    @JsonKey(name: 'order_cutoff_minutes') required this.orderCutoffMinutes,
  }) : _breakSlots = breakSlots,
       super._();

  factory _$SettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingsModelImplFromJson(json);

  final List<DateTime> _breakSlots;
  @override
  @JsonKey(
    name: 'break_slots',
    fromJson: _timestampListToDateTime,
    toJson: _dateTimeListToTimestamp,
  )
  List<DateTime> get breakSlots {
    if (_breakSlots is EqualUnmodifiableListView) return _breakSlots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_breakSlots);
  }

  @override
  @JsonKey(name: 'order_cutoff_minutes')
  final int orderCutoffMinutes;

  @override
  String toString() {
    return 'SettingsModel(breakSlots: $breakSlots, orderCutoffMinutes: $orderCutoffMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsModelImpl &&
            const DeepCollectionEquality().equals(
              other._breakSlots,
              _breakSlots,
            ) &&
            (identical(other.orderCutoffMinutes, orderCutoffMinutes) ||
                other.orderCutoffMinutes == orderCutoffMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_breakSlots),
    orderCutoffMinutes,
  );

  /// Create a copy of SettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsModelImplCopyWith<_$SettingsModelImpl> get copyWith =>
      __$$SettingsModelImplCopyWithImpl<_$SettingsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingsModelImplToJson(this);
  }
}

abstract class _SettingsModel extends SettingsModel {
  const factory _SettingsModel({
    @JsonKey(
      name: 'break_slots',
      fromJson: _timestampListToDateTime,
      toJson: _dateTimeListToTimestamp,
    )
    required final List<DateTime> breakSlots,
    @JsonKey(name: 'order_cutoff_minutes')
    required final int orderCutoffMinutes,
  }) = _$SettingsModelImpl;
  const _SettingsModel._() : super._();

  factory _SettingsModel.fromJson(Map<String, dynamic> json) =
      _$SettingsModelImpl.fromJson;

  @override
  @JsonKey(
    name: 'break_slots',
    fromJson: _timestampListToDateTime,
    toJson: _dateTimeListToTimestamp,
  )
  List<DateTime> get breakSlots;
  @override
  @JsonKey(name: 'order_cutoff_minutes')
  int get orderCutoffMinutes;

  /// Create a copy of SettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingsModelImplCopyWith<_$SettingsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
