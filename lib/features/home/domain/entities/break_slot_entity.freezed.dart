// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'break_slot_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BreakSlotEntity {
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  int get dayOfWeek => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Create a copy of BreakSlotEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreakSlotEntityCopyWith<BreakSlotEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreakSlotEntityCopyWith<$Res> {
  factory $BreakSlotEntityCopyWith(
    BreakSlotEntity value,
    $Res Function(BreakSlotEntity) then,
  ) = _$BreakSlotEntityCopyWithImpl<$Res, BreakSlotEntity>;
  @useResult
  $Res call({
    DateTime startTime,
    DateTime endTime,
    int dayOfWeek,
    String label,
    bool isActive,
  });
}

/// @nodoc
class _$BreakSlotEntityCopyWithImpl<$Res, $Val extends BreakSlotEntity>
    implements $BreakSlotEntityCopyWith<$Res> {
  _$BreakSlotEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BreakSlotEntity
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
abstract class _$$BreakSlotEntityImplCopyWith<$Res>
    implements $BreakSlotEntityCopyWith<$Res> {
  factory _$$BreakSlotEntityImplCopyWith(
    _$BreakSlotEntityImpl value,
    $Res Function(_$BreakSlotEntityImpl) then,
  ) = __$$BreakSlotEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime startTime,
    DateTime endTime,
    int dayOfWeek,
    String label,
    bool isActive,
  });
}

/// @nodoc
class __$$BreakSlotEntityImplCopyWithImpl<$Res>
    extends _$BreakSlotEntityCopyWithImpl<$Res, _$BreakSlotEntityImpl>
    implements _$$BreakSlotEntityImplCopyWith<$Res> {
  __$$BreakSlotEntityImplCopyWithImpl(
    _$BreakSlotEntityImpl _value,
    $Res Function(_$BreakSlotEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreakSlotEntity
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
      _$BreakSlotEntityImpl(
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

class _$BreakSlotEntityImpl implements _BreakSlotEntity {
  const _$BreakSlotEntityImpl({
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
    required this.label,
    this.isActive = true,
  });

  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final int dayOfWeek;
  @override
  final String label;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'BreakSlotEntity(startTime: $startTime, endTime: $endTime, dayOfWeek: $dayOfWeek, label: $label, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreakSlotEntityImpl &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, startTime, endTime, dayOfWeek, label, isActive);

  /// Create a copy of BreakSlotEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BreakSlotEntityImplCopyWith<_$BreakSlotEntityImpl> get copyWith =>
      __$$BreakSlotEntityImplCopyWithImpl<_$BreakSlotEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _BreakSlotEntity implements BreakSlotEntity {
  const factory _BreakSlotEntity({
    required final DateTime startTime,
    required final DateTime endTime,
    required final int dayOfWeek,
    required final String label,
    final bool isActive,
  }) = _$BreakSlotEntityImpl;

  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  int get dayOfWeek;
  @override
  String get label;
  @override
  bool get isActive;

  /// Create a copy of BreakSlotEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreakSlotEntityImplCopyWith<_$BreakSlotEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
