// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_assignment_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DeliveryAssignmentEntity {
  String get assignmentId => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  String get canteenName => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get deliveryFee => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;

  /// Create a copy of DeliveryAssignmentEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryAssignmentEntityCopyWith<DeliveryAssignmentEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryAssignmentEntityCopyWith<$Res> {
  factory $DeliveryAssignmentEntityCopyWith(
    DeliveryAssignmentEntity value,
    $Res Function(DeliveryAssignmentEntity) then,
  ) = _$DeliveryAssignmentEntityCopyWithImpl<$Res, DeliveryAssignmentEntity>;
  @useResult
  $Res call({
    String assignmentId,
    String orderId,
    String canteenName,
    double totalAmount,
    double deliveryFee,
    int itemCount,
    DateTime expiresAt,
  });
}

/// @nodoc
class _$DeliveryAssignmentEntityCopyWithImpl<
  $Res,
  $Val extends DeliveryAssignmentEntity
>
    implements $DeliveryAssignmentEntityCopyWith<$Res> {
  _$DeliveryAssignmentEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryAssignmentEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assignmentId = null,
    Object? orderId = null,
    Object? canteenName = null,
    Object? totalAmount = null,
    Object? deliveryFee = null,
    Object? itemCount = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _value.copyWith(
            assignmentId: null == assignmentId
                ? _value.assignmentId
                : assignmentId // ignore: cast_nullable_to_non_nullable
                      as String,
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String,
            canteenName: null == canteenName
                ? _value.canteenName
                : canteenName // ignore: cast_nullable_to_non_nullable
                      as String,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            deliveryFee: null == deliveryFee
                ? _value.deliveryFee
                : deliveryFee // ignore: cast_nullable_to_non_nullable
                      as double,
            itemCount: null == itemCount
                ? _value.itemCount
                : itemCount // ignore: cast_nullable_to_non_nullable
                      as int,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeliveryAssignmentEntityImplCopyWith<$Res>
    implements $DeliveryAssignmentEntityCopyWith<$Res> {
  factory _$$DeliveryAssignmentEntityImplCopyWith(
    _$DeliveryAssignmentEntityImpl value,
    $Res Function(_$DeliveryAssignmentEntityImpl) then,
  ) = __$$DeliveryAssignmentEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String assignmentId,
    String orderId,
    String canteenName,
    double totalAmount,
    double deliveryFee,
    int itemCount,
    DateTime expiresAt,
  });
}

/// @nodoc
class __$$DeliveryAssignmentEntityImplCopyWithImpl<$Res>
    extends
        _$DeliveryAssignmentEntityCopyWithImpl<
          $Res,
          _$DeliveryAssignmentEntityImpl
        >
    implements _$$DeliveryAssignmentEntityImplCopyWith<$Res> {
  __$$DeliveryAssignmentEntityImplCopyWithImpl(
    _$DeliveryAssignmentEntityImpl _value,
    $Res Function(_$DeliveryAssignmentEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryAssignmentEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assignmentId = null,
    Object? orderId = null,
    Object? canteenName = null,
    Object? totalAmount = null,
    Object? deliveryFee = null,
    Object? itemCount = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _$DeliveryAssignmentEntityImpl(
        assignmentId: null == assignmentId
            ? _value.assignmentId
            : assignmentId // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String,
        canteenName: null == canteenName
            ? _value.canteenName
            : canteenName // ignore: cast_nullable_to_non_nullable
                  as String,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        deliveryFee: null == deliveryFee
            ? _value.deliveryFee
            : deliveryFee // ignore: cast_nullable_to_non_nullable
                  as double,
        itemCount: null == itemCount
            ? _value.itemCount
            : itemCount // ignore: cast_nullable_to_non_nullable
                  as int,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$DeliveryAssignmentEntityImpl implements _DeliveryAssignmentEntity {
  const _$DeliveryAssignmentEntityImpl({
    required this.assignmentId,
    required this.orderId,
    required this.canteenName,
    required this.totalAmount,
    required this.deliveryFee,
    required this.itemCount,
    required this.expiresAt,
  });

  @override
  final String assignmentId;
  @override
  final String orderId;
  @override
  final String canteenName;
  @override
  final double totalAmount;
  @override
  final double deliveryFee;
  @override
  final int itemCount;
  @override
  final DateTime expiresAt;

  @override
  String toString() {
    return 'DeliveryAssignmentEntity(assignmentId: $assignmentId, orderId: $orderId, canteenName: $canteenName, totalAmount: $totalAmount, deliveryFee: $deliveryFee, itemCount: $itemCount, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryAssignmentEntityImpl &&
            (identical(other.assignmentId, assignmentId) ||
                other.assignmentId == assignmentId) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.canteenName, canteenName) ||
                other.canteenName == canteenName) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    assignmentId,
    orderId,
    canteenName,
    totalAmount,
    deliveryFee,
    itemCount,
    expiresAt,
  );

  /// Create a copy of DeliveryAssignmentEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryAssignmentEntityImplCopyWith<_$DeliveryAssignmentEntityImpl>
  get copyWith =>
      __$$DeliveryAssignmentEntityImplCopyWithImpl<
        _$DeliveryAssignmentEntityImpl
      >(this, _$identity);
}

abstract class _DeliveryAssignmentEntity implements DeliveryAssignmentEntity {
  const factory _DeliveryAssignmentEntity({
    required final String assignmentId,
    required final String orderId,
    required final String canteenName,
    required final double totalAmount,
    required final double deliveryFee,
    required final int itemCount,
    required final DateTime expiresAt,
  }) = _$DeliveryAssignmentEntityImpl;

  @override
  String get assignmentId;
  @override
  String get orderId;
  @override
  String get canteenName;
  @override
  double get totalAmount;
  @override
  double get deliveryFee;
  @override
  int get itemCount;
  @override
  DateTime get expiresAt;

  /// Create a copy of DeliveryAssignmentEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryAssignmentEntityImplCopyWith<_$DeliveryAssignmentEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}
