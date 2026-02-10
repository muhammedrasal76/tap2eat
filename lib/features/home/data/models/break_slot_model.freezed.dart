// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'break_slot_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BreakSlotModel _$BreakSlotModelFromJson(Map<String, dynamic> json) {
  return _BreakSlotModel.fromJson(json);
}

/// @nodoc
mixin _$BreakSlotModel {
  @JsonKey(
    name: 'start_time',
    fromJson: _timestampToDateTime,
    toJson: _dateTimeToTimestamp,
  )
  DateTime get startTime => throw _privateConstructorUsedError;
  @JsonKey(
    name: 'end_time',
    fromJson: _timestampToDateTime,
    toJson: _dateTimeToTimestamp,
  )
  DateTime get endTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'day_of_week')
  int get dayOfWeek => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this BreakSlotModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BreakSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreakSlotModelCopyWith<BreakSlotModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreakSlotModelCopyWith<$Res> {
  factory $BreakSlotModelCopyWith(
    BreakSlotModel value,
    $Res Function(BreakSlotModel) then,
  ) = _$BreakSlotModelCopyWithImpl<$Res, BreakSlotModel>;
  @useResult
  $Res call({
    @JsonKey(
      name: 'start_time',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    DateTime startTime,
    @JsonKey(
      name: 'end_time',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    DateTime endTime,
    @JsonKey(name: 'day_of_week') int dayOfWeek,
    String label,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class _$BreakSlotModelCopyWithImpl<$Res, $Val extends BreakSlotModel>
    implements $BreakSlotModelCopyWith<$Res> {
  _$BreakSlotModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BreakSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
    Object? dayOfWeek = null,
    Object? label = null,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            dayOfWeek: null == dayOfWeek
                ? _value.dayOfWeek
                : dayOfWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BreakSlotModelImplCopyWith<$Res>
    implements $BreakSlotModelCopyWith<$Res> {
  factory _$$BreakSlotModelImplCopyWith(
    _$BreakSlotModelImpl value,
    $Res Function(_$BreakSlotModelImpl) then,
  ) = __$$BreakSlotModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(
      name: 'start_time',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    DateTime startTime,
    @JsonKey(
      name: 'end_time',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    DateTime endTime,
    @JsonKey(name: 'day_of_week') int dayOfWeek,
    String label,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class __$$BreakSlotModelImplCopyWithImpl<$Res>
    extends _$BreakSlotModelCopyWithImpl<$Res, _$BreakSlotModelImpl>
    implements _$$BreakSlotModelImplCopyWith<$Res> {
  __$$BreakSlotModelImplCopyWithImpl(
    _$BreakSlotModelImpl _value,
    $Res Function(_$BreakSlotModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreakSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
    Object? dayOfWeek = null,
    Object? label = null,
    Object? isActive = null,
  }) {
    return _then(
      _$BreakSlotModelImpl(
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dayOfWeek: null == dayOfWeek
            ? _value.dayOfWeek
            : dayOfWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BreakSlotModelImpl extends _BreakSlotModel {
  const _$BreakSlotModelImpl({
    @JsonKey(
      name: 'start_time',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    required this.startTime,
    @JsonKey(
      name: 'end_time',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    required this.endTime,
    @JsonKey(name: 'day_of_week') required this.dayOfWeek,
    required this.label,
    @JsonKey(name: 'is_active') this.isActive = true,
  }) : super._();

  factory _$BreakSlotModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BreakSlotModelImplFromJson(json);

  @override
  @JsonKey(
    name: 'start_time',
    fromJson: _timestampToDateTime,
    toJson: _dateTimeToTimestamp,
  )
  final DateTime startTime;
  @override
  @JsonKey(
    name: 'end_time',
    fromJson: _timestampToDateTime,
    toJson: _dateTimeToTimestamp,
  )
  final DateTime endTime;
  @override
  @JsonKey(name: 'day_of_week')
  final int dayOfWeek;
  @override
  final String label;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'BreakSlotModel(startTime: $startTime, endTime: $endTime, dayOfWeek: $dayOfWeek, label: $label, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreakSlotModelImpl &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, startTime, endTime, dayOfWeek, label, isActive);

  /// Create a copy of BreakSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BreakSlotModelImplCopyWith<_$BreakSlotModelImpl> get copyWith =>
      __$$BreakSlotModelImplCopyWithImpl<_$BreakSlotModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BreakSlotModelImplToJson(this);
  }
}

abstract class _BreakSlotModel extends BreakSlotModel {
  const factory _BreakSlotModel({
    @JsonKey(
      name: 'start_time',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    required final DateTime startTime,
    @JsonKey(
      name: 'end_time',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    required final DateTime endTime,
    @JsonKey(name: 'day_of_week') required final int dayOfWeek,
    required final String label,
    @JsonKey(name: 'is_active') final bool isActive,
  }) = _$BreakSlotModelImpl;
  const _BreakSlotModel._() : super._();

  factory _BreakSlotModel.fromJson(Map<String, dynamic> json) =
      _$BreakSlotModelImpl.fromJson;

  @override
  @JsonKey(
    name: 'start_time',
    fromJson: _timestampToDateTime,
    toJson: _dateTimeToTimestamp,
  )
  DateTime get startTime;
  @override
  @JsonKey(
    name: 'end_time',
    fromJson: _timestampToDateTime,
    toJson: _dateTimeToTimestamp,
  )
  DateTime get endTime;
  @override
  @JsonKey(name: 'day_of_week')
  int get dayOfWeek;
  @override
  String get label;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of BreakSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreakSlotModelImplCopyWith<_$BreakSlotModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
