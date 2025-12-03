// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RecentOrderModel _$RecentOrderModelFromJson(Map<String, dynamic> json) {
  return _RecentOrderModel.fromJson(json);
}

/// @nodoc
mixin _$RecentOrderModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'canteen_id')
  String get canteenId => throw _privateConstructorUsedError;
  @JsonKey(name: 'canteen_name')
  String? get canteenName => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  List<OrderItemModel> get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(
    name: 'fulfillment_slot',
    fromJson: _timestampToDateTime,
    toJson: _dateTimeToTimestamp,
  )
  DateTime get fulfillmentSlot => throw _privateConstructorUsedError;
  @JsonKey(name: 'fulfillment_type')
  String get fulfillmentType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_student_id')
  String? get deliveryStudentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_fee')
  double? get deliveryFee => throw _privateConstructorUsedError;
  @JsonKey(
    name: 'created_at',
    fromJson: _timestampToDateTime,
    toJson: _dateTimeToTimestamp,
  )
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(
    name: 'updated_at',
    fromJson: _timestampToDateTime,
    toJson: _dateTimeToTimestamp,
  )
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RecentOrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecentOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentOrderModelCopyWith<RecentOrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentOrderModelCopyWith<$Res> {
  factory $RecentOrderModelCopyWith(
    RecentOrderModel value,
    $Res Function(RecentOrderModel) then,
  ) = _$RecentOrderModelCopyWithImpl<$Res, RecentOrderModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'canteen_id') String canteenId,
    @JsonKey(name: 'canteen_name') String? canteenName,
    @JsonKey(name: 'user_id') String userId,
    List<OrderItemModel> items,
    @JsonKey(name: 'total_amount') double totalAmount,
    @JsonKey(
      name: 'fulfillment_slot',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    DateTime fulfillmentSlot,
    @JsonKey(name: 'fulfillment_type') String fulfillmentType,
    String status,
    @JsonKey(name: 'delivery_student_id') String? deliveryStudentId,
    @JsonKey(name: 'delivery_fee') double? deliveryFee,
    @JsonKey(
      name: 'created_at',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    DateTime createdAt,
    @JsonKey(
      name: 'updated_at',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    DateTime updatedAt,
  });
}

/// @nodoc
class _$RecentOrderModelCopyWithImpl<$Res, $Val extends RecentOrderModel>
    implements $RecentOrderModelCopyWith<$Res> {
  _$RecentOrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecentOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? canteenId = null,
    Object? canteenName = freezed,
    Object? userId = null,
    Object? items = null,
    Object? totalAmount = null,
    Object? fulfillmentSlot = null,
    Object? fulfillmentType = null,
    Object? status = null,
    Object? deliveryStudentId = freezed,
    Object? deliveryFee = freezed,
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
            canteenName: freezed == canteenName
                ? _value.canteenName
                : canteenName // ignore: cast_nullable_to_non_nullable
                      as String?,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderItemModel>,
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
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            deliveryStudentId: freezed == deliveryStudentId
                ? _value.deliveryStudentId
                : deliveryStudentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            deliveryFee: freezed == deliveryFee
                ? _value.deliveryFee
                : deliveryFee // ignore: cast_nullable_to_non_nullable
                      as double?,
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
abstract class _$$RecentOrderModelImplCopyWith<$Res>
    implements $RecentOrderModelCopyWith<$Res> {
  factory _$$RecentOrderModelImplCopyWith(
    _$RecentOrderModelImpl value,
    $Res Function(_$RecentOrderModelImpl) then,
  ) = __$$RecentOrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'canteen_id') String canteenId,
    @JsonKey(name: 'canteen_name') String? canteenName,
    @JsonKey(name: 'user_id') String userId,
    List<OrderItemModel> items,
    @JsonKey(name: 'total_amount') double totalAmount,
    @JsonKey(
      name: 'fulfillment_slot',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    DateTime fulfillmentSlot,
    @JsonKey(name: 'fulfillment_type') String fulfillmentType,
    String status,
    @JsonKey(name: 'delivery_student_id') String? deliveryStudentId,
    @JsonKey(name: 'delivery_fee') double? deliveryFee,
    @JsonKey(
      name: 'created_at',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    DateTime createdAt,
    @JsonKey(
      name: 'updated_at',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$RecentOrderModelImplCopyWithImpl<$Res>
    extends _$RecentOrderModelCopyWithImpl<$Res, _$RecentOrderModelImpl>
    implements _$$RecentOrderModelImplCopyWith<$Res> {
  __$$RecentOrderModelImplCopyWithImpl(
    _$RecentOrderModelImpl _value,
    $Res Function(_$RecentOrderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecentOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? canteenId = null,
    Object? canteenName = freezed,
    Object? userId = null,
    Object? items = null,
    Object? totalAmount = null,
    Object? fulfillmentSlot = null,
    Object? fulfillmentType = null,
    Object? status = null,
    Object? deliveryStudentId = freezed,
    Object? deliveryFee = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$RecentOrderModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        canteenId: null == canteenId
            ? _value.canteenId
            : canteenId // ignore: cast_nullable_to_non_nullable
                  as String,
        canteenName: freezed == canteenName
            ? _value.canteenName
            : canteenName // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderItemModel>,
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
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        deliveryStudentId: freezed == deliveryStudentId
            ? _value.deliveryStudentId
            : deliveryStudentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        deliveryFee: freezed == deliveryFee
            ? _value.deliveryFee
            : deliveryFee // ignore: cast_nullable_to_non_nullable
                  as double?,
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
@JsonSerializable()
class _$RecentOrderModelImpl extends _RecentOrderModel {
  const _$RecentOrderModelImpl({
    required this.id,
    @JsonKey(name: 'canteen_id') required this.canteenId,
    @JsonKey(name: 'canteen_name') this.canteenName,
    @JsonKey(name: 'user_id') required this.userId,
    required final List<OrderItemModel> items,
    @JsonKey(name: 'total_amount') required this.totalAmount,
    @JsonKey(
      name: 'fulfillment_slot',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    required this.fulfillmentSlot,
    @JsonKey(name: 'fulfillment_type') required this.fulfillmentType,
    required this.status,
    @JsonKey(name: 'delivery_student_id') this.deliveryStudentId,
    @JsonKey(name: 'delivery_fee') this.deliveryFee,
    @JsonKey(
      name: 'created_at',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    required this.createdAt,
    @JsonKey(
      name: 'updated_at',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    required this.updatedAt,
  }) : _items = items,
       super._();

  factory _$RecentOrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentOrderModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'canteen_id')
  final String canteenId;
  @override
  @JsonKey(name: 'canteen_name')
  final String? canteenName;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  final List<OrderItemModel> _items;
  @override
  List<OrderItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  @JsonKey(
    name: 'fulfillment_slot',
    fromJson: _timestampToDateTime,
    toJson: _dateTimeToTimestamp,
  )
  final DateTime fulfillmentSlot;
  @override
  @JsonKey(name: 'fulfillment_type')
  final String fulfillmentType;
  @override
  final String status;
  @override
  @JsonKey(name: 'delivery_student_id')
  final String? deliveryStudentId;
  @override
  @JsonKey(name: 'delivery_fee')
  final double? deliveryFee;
  @override
  @JsonKey(
    name: 'created_at',
    fromJson: _timestampToDateTime,
    toJson: _dateTimeToTimestamp,
  )
  final DateTime createdAt;
  @override
  @JsonKey(
    name: 'updated_at',
    fromJson: _timestampToDateTime,
    toJson: _dateTimeToTimestamp,
  )
  final DateTime updatedAt;

  @override
  String toString() {
    return 'RecentOrderModel(id: $id, canteenId: $canteenId, canteenName: $canteenName, userId: $userId, items: $items, totalAmount: $totalAmount, fulfillmentSlot: $fulfillmentSlot, fulfillmentType: $fulfillmentType, status: $status, deliveryStudentId: $deliveryStudentId, deliveryFee: $deliveryFee, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentOrderModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of RecentOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentOrderModelImplCopyWith<_$RecentOrderModelImpl> get copyWith =>
      __$$RecentOrderModelImplCopyWithImpl<_$RecentOrderModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentOrderModelImplToJson(this);
  }
}

abstract class _RecentOrderModel extends RecentOrderModel {
  const factory _RecentOrderModel({
    required final String id,
    @JsonKey(name: 'canteen_id') required final String canteenId,
    @JsonKey(name: 'canteen_name') final String? canteenName,
    @JsonKey(name: 'user_id') required final String userId,
    required final List<OrderItemModel> items,
    @JsonKey(name: 'total_amount') required final double totalAmount,
    @JsonKey(
      name: 'fulfillment_slot',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    required final DateTime fulfillmentSlot,
    @JsonKey(name: 'fulfillment_type') required final String fulfillmentType,
    required final String status,
    @JsonKey(name: 'delivery_student_id') final String? deliveryStudentId,
    @JsonKey(name: 'delivery_fee') final double? deliveryFee,
    @JsonKey(
      name: 'created_at',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    required final DateTime createdAt,
    @JsonKey(
      name: 'updated_at',
      fromJson: _timestampToDateTime,
      toJson: _dateTimeToTimestamp,
    )
    required final DateTime updatedAt,
  }) = _$RecentOrderModelImpl;
  const _RecentOrderModel._() : super._();

  factory _RecentOrderModel.fromJson(Map<String, dynamic> json) =
      _$RecentOrderModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'canteen_id')
  String get canteenId;
  @override
  @JsonKey(name: 'canteen_name')
  String? get canteenName;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  List<OrderItemModel> get items;
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  @JsonKey(
    name: 'fulfillment_slot',
    fromJson: _timestampToDateTime,
    toJson: _dateTimeToTimestamp,
  )
  DateTime get fulfillmentSlot;
  @override
  @JsonKey(name: 'fulfillment_type')
  String get fulfillmentType;
  @override
  String get status;
  @override
  @JsonKey(name: 'delivery_student_id')
  String? get deliveryStudentId;
  @override
  @JsonKey(name: 'delivery_fee')
  double? get deliveryFee;
  @override
  @JsonKey(
    name: 'created_at',
    fromJson: _timestampToDateTime,
    toJson: _dateTimeToTimestamp,
  )
  DateTime get createdAt;
  @override
  @JsonKey(
    name: 'updated_at',
    fromJson: _timestampToDateTime,
    toJson: _dateTimeToTimestamp,
  )
  DateTime get updatedAt;

  /// Create a copy of RecentOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentOrderModelImplCopyWith<_$RecentOrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) {
  return _OrderItemModel.fromJson(json);
}

/// @nodoc
mixin _$OrderItemModel {
  @JsonKey(name: 'menu_item_id')
  String get menuItemId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this OrderItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemModelCopyWith<OrderItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemModelCopyWith<$Res> {
  factory $OrderItemModelCopyWith(
    OrderItemModel value,
    $Res Function(OrderItemModel) then,
  ) = _$OrderItemModelCopyWithImpl<$Res, OrderItemModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'menu_item_id') String menuItemId,
    String name,
    int quantity,
    double price,
    @JsonKey(name: 'image_url') String? imageUrl,
  });
}

/// @nodoc
class _$OrderItemModelCopyWithImpl<$Res, $Val extends OrderItemModel>
    implements $OrderItemModelCopyWith<$Res> {
  _$OrderItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? menuItemId = null,
    Object? name = null,
    Object? quantity = null,
    Object? price = null,
    Object? imageUrl = freezed,
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
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderItemModelImplCopyWith<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  factory _$$OrderItemModelImplCopyWith(
    _$OrderItemModelImpl value,
    $Res Function(_$OrderItemModelImpl) then,
  ) = __$$OrderItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'menu_item_id') String menuItemId,
    String name,
    int quantity,
    double price,
    @JsonKey(name: 'image_url') String? imageUrl,
  });
}

/// @nodoc
class __$$OrderItemModelImplCopyWithImpl<$Res>
    extends _$OrderItemModelCopyWithImpl<$Res, _$OrderItemModelImpl>
    implements _$$OrderItemModelImplCopyWith<$Res> {
  __$$OrderItemModelImplCopyWithImpl(
    _$OrderItemModelImpl _value,
    $Res Function(_$OrderItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? menuItemId = null,
    Object? name = null,
    Object? quantity = null,
    Object? price = null,
    Object? imageUrl = freezed,
  }) {
    return _then(
      _$OrderItemModelImpl(
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
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemModelImpl extends _OrderItemModel {
  const _$OrderItemModelImpl({
    @JsonKey(name: 'menu_item_id') required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.price,
    @JsonKey(name: 'image_url') this.imageUrl,
  }) : super._();

  factory _$OrderItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'menu_item_id')
  final String menuItemId;
  @override
  final String name;
  @override
  final int quantity;
  @override
  final double price;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  @override
  String toString() {
    return 'OrderItemModel(menuItemId: $menuItemId, name: $name, quantity: $quantity, price: $price, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemModelImpl &&
            (identical(other.menuItemId, menuItemId) ||
                other.menuItemId == menuItemId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, menuItemId, name, quantity, price, imageUrl);

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      __$$OrderItemModelImplCopyWithImpl<_$OrderItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemModelImplToJson(this);
  }
}

abstract class _OrderItemModel extends OrderItemModel {
  const factory _OrderItemModel({
    @JsonKey(name: 'menu_item_id') required final String menuItemId,
    required final String name,
    required final int quantity,
    required final double price,
    @JsonKey(name: 'image_url') final String? imageUrl,
  }) = _$OrderItemModelImpl;
  const _OrderItemModel._() : super._();

  factory _OrderItemModel.fromJson(Map<String, dynamic> json) =
      _$OrderItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'menu_item_id')
  String get menuItemId;
  @override
  String get name;
  @override
  int get quantity;
  @override
  double get price;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
