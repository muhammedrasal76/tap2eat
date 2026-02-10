// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_order_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RecentOrderEntity {
  String get id => throw _privateConstructorUsedError;
  String get canteenId => throw _privateConstructorUsedError;
  String get canteenName => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  List<OrderItemEntity> get items => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  DateTime get fulfillmentSlot => throw _privateConstructorUsedError;
  FulfillmentType get fulfillmentType => throw _privateConstructorUsedError;
  OrderStatus get status => throw _privateConstructorUsedError;
  String? get deliveryStudentId => throw _privateConstructorUsedError;
  double get deliveryFee => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of RecentOrderEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentOrderEntityCopyWith<RecentOrderEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentOrderEntityCopyWith<$Res> {
  factory $RecentOrderEntityCopyWith(
    RecentOrderEntity value,
    $Res Function(RecentOrderEntity) then,
  ) = _$RecentOrderEntityCopyWithImpl<$Res, RecentOrderEntity>;
  @useResult
  $Res call({
    String id,
    String canteenId,
    String canteenName,
    String userId,
    List<OrderItemEntity> items,
    double totalAmount,
    DateTime fulfillmentSlot,
    FulfillmentType fulfillmentType,
    OrderStatus status,
    String? deliveryStudentId,
    double deliveryFee,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$RecentOrderEntityCopyWithImpl<$Res, $Val extends RecentOrderEntity>
    implements $RecentOrderEntityCopyWith<$Res> {
  _$RecentOrderEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecentOrderEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? canteenId = null,
    Object? canteenName = null,
    Object? userId = null,
    Object? items = null,
    Object? totalAmount = null,
    Object? fulfillmentSlot = null,
    Object? fulfillmentType = null,
    Object? status = null,
    Object? deliveryStudentId = freezed,
    Object? deliveryFee = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            canteenId: null == canteenId
                ? _value.canteenId
                : canteenId // ignore: cast_nullable_to_non_nullable
                      as String,
            canteenName: null == canteenName
                ? _value.canteenName
                : canteenName // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderItemEntity>,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            fulfillmentSlot: null == fulfillmentSlot
                ? _value.fulfillmentSlot
                : fulfillmentSlot // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            fulfillmentType: null == fulfillmentType
                ? _value.fulfillmentType
                : fulfillmentType // ignore: cast_nullable_to_non_nullable
                      as FulfillmentType,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OrderStatus,
            deliveryStudentId: freezed == deliveryStudentId
                ? _value.deliveryStudentId
                : deliveryStudentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            deliveryFee: null == deliveryFee
                ? _value.deliveryFee
                : deliveryFee // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecentOrderEntityImplCopyWith<$Res>
    implements $RecentOrderEntityCopyWith<$Res> {
  factory _$$RecentOrderEntityImplCopyWith(
    _$RecentOrderEntityImpl value,
    $Res Function(_$RecentOrderEntityImpl) then,
  ) = __$$RecentOrderEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String canteenId,
    String canteenName,
    String userId,
    List<OrderItemEntity> items,
    double totalAmount,
    DateTime fulfillmentSlot,
    FulfillmentType fulfillmentType,
    OrderStatus status,
    String? deliveryStudentId,
    double deliveryFee,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$RecentOrderEntityImplCopyWithImpl<$Res>
    extends _$RecentOrderEntityCopyWithImpl<$Res, _$RecentOrderEntityImpl>
    implements _$$RecentOrderEntityImplCopyWith<$Res> {
  __$$RecentOrderEntityImplCopyWithImpl(
    _$RecentOrderEntityImpl _value,
    $Res Function(_$RecentOrderEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecentOrderEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? canteenId = null,
    Object? canteenName = null,
    Object? userId = null,
    Object? items = null,
    Object? totalAmount = null,
    Object? fulfillmentSlot = null,
    Object? fulfillmentType = null,
    Object? status = null,
    Object? deliveryStudentId = freezed,
    Object? deliveryFee = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$RecentOrderEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        canteenId: null == canteenId
            ? _value.canteenId
            : canteenId // ignore: cast_nullable_to_non_nullable
                  as String,
        canteenName: null == canteenName
            ? _value.canteenName
            : canteenName // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderItemEntity>,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        fulfillmentSlot: null == fulfillmentSlot
            ? _value.fulfillmentSlot
            : fulfillmentSlot // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        fulfillmentType: null == fulfillmentType
            ? _value.fulfillmentType
            : fulfillmentType // ignore: cast_nullable_to_non_nullable
                  as FulfillmentType,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OrderStatus,
        deliveryStudentId: freezed == deliveryStudentId
            ? _value.deliveryStudentId
            : deliveryStudentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        deliveryFee: null == deliveryFee
            ? _value.deliveryFee
            : deliveryFee // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$RecentOrderEntityImpl implements _RecentOrderEntity {
  const _$RecentOrderEntityImpl({
    required this.id,
    required this.canteenId,
    required this.canteenName,
    required this.userId,
    required final List<OrderItemEntity> items,
    required this.totalAmount,
    required this.fulfillmentSlot,
    required this.fulfillmentType,
    required this.status,
    this.deliveryStudentId,
    required this.deliveryFee,
    required this.createdAt,
    required this.updatedAt,
  }) : _items = items;

  @override
  final String id;
  @override
  final String canteenId;
  @override
  final String canteenName;
  @override
  final String userId;
  final List<OrderItemEntity> _items;
  @override
  List<OrderItemEntity> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final double totalAmount;
  @override
  final DateTime fulfillmentSlot;
  @override
  final FulfillmentType fulfillmentType;
  @override
  final OrderStatus status;
  @override
  final String? deliveryStudentId;
  @override
  final double deliveryFee;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'RecentOrderEntity(id: $id, canteenId: $canteenId, canteenName: $canteenName, userId: $userId, items: $items, totalAmount: $totalAmount, fulfillmentSlot: $fulfillmentSlot, fulfillmentType: $fulfillmentType, status: $status, deliveryStudentId: $deliveryStudentId, deliveryFee: $deliveryFee, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentOrderEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.canteenId, canteenId) ||
                other.canteenId == canteenId) &&
            (identical(other.canteenName, canteenName) ||
                other.canteenName == canteenName) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.fulfillmentSlot, fulfillmentSlot) ||
                other.fulfillmentSlot == fulfillmentSlot) &&
            (identical(other.fulfillmentType, fulfillmentType) ||
                other.fulfillmentType == fulfillmentType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.deliveryStudentId, deliveryStudentId) ||
                other.deliveryStudentId == deliveryStudentId) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    canteenId,
    canteenName,
    userId,
    const DeepCollectionEquality().hash(_items),
    totalAmount,
    fulfillmentSlot,
    fulfillmentType,
    status,
    deliveryStudentId,
    deliveryFee,
    createdAt,
    updatedAt,
  );

  /// Create a copy of RecentOrderEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentOrderEntityImplCopyWith<_$RecentOrderEntityImpl> get copyWith =>
      __$$RecentOrderEntityImplCopyWithImpl<_$RecentOrderEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _RecentOrderEntity implements RecentOrderEntity {
  const factory _RecentOrderEntity({
    required final String id,
    required final String canteenId,
    required final String canteenName,
    required final String userId,
    required final List<OrderItemEntity> items,
    required final double totalAmount,
    required final DateTime fulfillmentSlot,
    required final FulfillmentType fulfillmentType,
    required final OrderStatus status,
    final String? deliveryStudentId,
    required final double deliveryFee,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$RecentOrderEntityImpl;

  @override
  String get id;
  @override
  String get canteenId;
  @override
  String get canteenName;
  @override
  String get userId;
  @override
  List<OrderItemEntity> get items;
  @override
  double get totalAmount;
  @override
  DateTime get fulfillmentSlot;
  @override
  FulfillmentType get fulfillmentType;
  @override
  OrderStatus get status;
  @override
  String? get deliveryStudentId;
  @override
  double get deliveryFee;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of RecentOrderEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentOrderEntityImplCopyWith<_$RecentOrderEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrderItemEntity {
  String get menuItemId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

  /// Create a copy of OrderItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemEntityCopyWith<OrderItemEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemEntityCopyWith<$Res> {
  factory $OrderItemEntityCopyWith(
    OrderItemEntity value,
    $Res Function(OrderItemEntity) then,
  ) = _$OrderItemEntityCopyWithImpl<$Res, OrderItemEntity>;
  @useResult
  $Res call({String menuItemId, String name, int quantity, double price});
}

/// @nodoc
class _$OrderItemEntityCopyWithImpl<$Res, $Val extends OrderItemEntity>
    implements $OrderItemEntityCopyWith<$Res> {
  _$OrderItemEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? menuItemId = null,
    Object? name = null,
    Object? quantity = null,
    Object? price = null,
  }) {
    return _then(
      _value.copyWith(
            menuItemId: null == menuItemId
                ? _value.menuItemId
                : menuItemId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderItemEntityImplCopyWith<$Res>
    implements $OrderItemEntityCopyWith<$Res> {
  factory _$$OrderItemEntityImplCopyWith(
    _$OrderItemEntityImpl value,
    $Res Function(_$OrderItemEntityImpl) then,
  ) = __$$OrderItemEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String menuItemId, String name, int quantity, double price});
}

/// @nodoc
class __$$OrderItemEntityImplCopyWithImpl<$Res>
    extends _$OrderItemEntityCopyWithImpl<$Res, _$OrderItemEntityImpl>
    implements _$$OrderItemEntityImplCopyWith<$Res> {
  __$$OrderItemEntityImplCopyWithImpl(
    _$OrderItemEntityImpl _value,
    $Res Function(_$OrderItemEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? menuItemId = null,
    Object? name = null,
    Object? quantity = null,
    Object? price = null,
  }) {
    return _then(
      _$OrderItemEntityImpl(
        menuItemId: null == menuItemId
            ? _value.menuItemId
            : menuItemId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$OrderItemEntityImpl implements _OrderItemEntity {
  const _$OrderItemEntityImpl({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  @override
  final String menuItemId;
  @override
  final String name;
  @override
  final int quantity;
  @override
  final double price;

  @override
  String toString() {
    return 'OrderItemEntity(menuItemId: $menuItemId, name: $name, quantity: $quantity, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemEntityImpl &&
            (identical(other.menuItemId, menuItemId) ||
                other.menuItemId == menuItemId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, menuItemId, name, quantity, price);

  /// Create a copy of OrderItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemEntityImplCopyWith<_$OrderItemEntityImpl> get copyWith =>
      __$$OrderItemEntityImplCopyWithImpl<_$OrderItemEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _OrderItemEntity implements OrderItemEntity {
  const factory _OrderItemEntity({
    required final String menuItemId,
    required final String name,
    required final int quantity,
    required final double price,
  }) = _$OrderItemEntityImpl;

  @override
  String get menuItemId;
  @override
  String get name;
  @override
  int get quantity;
  @override
  double get price;

  /// Create a copy of OrderItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemEntityImplCopyWith<_$OrderItemEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
