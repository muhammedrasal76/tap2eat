// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MenuItemEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  int get stock => throw _privateConstructorUsedError;

  /// Create a copy of MenuItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MenuItemEntityCopyWith<MenuItemEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenuItemEntityCopyWith<$Res> {
  factory $MenuItemEntityCopyWith(
    MenuItemEntity value,
    $Res Function(MenuItemEntity) then,
  ) = _$MenuItemEntityCopyWithImpl<$Res, MenuItemEntity>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    double price,
    String category,
    String? imageUrl,
    bool isAvailable,
    int stock,
  });
}

/// @nodoc
class _$MenuItemEntityCopyWithImpl<$Res, $Val extends MenuItemEntity>
    implements $MenuItemEntityCopyWith<$Res> {
  _$MenuItemEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MenuItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? category = null,
    Object? imageUrl = freezed,
    Object? isAvailable = null,
    Object? stock = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            isAvailable: null == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            stock: null == stock
                ? _value.stock
                : stock // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MenuItemEntityImplCopyWith<$Res>
    implements $MenuItemEntityCopyWith<$Res> {
  factory _$$MenuItemEntityImplCopyWith(
    _$MenuItemEntityImpl value,
    $Res Function(_$MenuItemEntityImpl) then,
  ) = __$$MenuItemEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    double price,
    String category,
    String? imageUrl,
    bool isAvailable,
    int stock,
  });
}

/// @nodoc
class __$$MenuItemEntityImplCopyWithImpl<$Res>
    extends _$MenuItemEntityCopyWithImpl<$Res, _$MenuItemEntityImpl>
    implements _$$MenuItemEntityImplCopyWith<$Res> {
  __$$MenuItemEntityImplCopyWithImpl(
    _$MenuItemEntityImpl _value,
    $Res Function(_$MenuItemEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MenuItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? category = null,
    Object? imageUrl = freezed,
    Object? isAvailable = null,
    Object? stock = null,
  }) {
    return _then(
      _$MenuItemEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        isAvailable: null == isAvailable
            ? _value.isAvailable
            : isAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        stock: null == stock
            ? _value.stock
            : stock // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$MenuItemEntityImpl implements _MenuItemEntity {
  const _$MenuItemEntityImpl({
    this.id = '',
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrl,
    required this.isAvailable,
    required this.stock,
  });

  @override
  @JsonKey()
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final double price;
  @override
  final String category;
  @override
  final String? imageUrl;
  @override
  final bool isAvailable;
  @override
  final int stock;

  @override
  String toString() {
    return 'MenuItemEntity(id: $id, name: $name, description: $description, price: $price, category: $category, imageUrl: $imageUrl, isAvailable: $isAvailable, stock: $stock)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MenuItemEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.stock, stock) || other.stock == stock));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    price,
    category,
    imageUrl,
    isAvailable,
    stock,
  );

  /// Create a copy of MenuItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MenuItemEntityImplCopyWith<_$MenuItemEntityImpl> get copyWith =>
      __$$MenuItemEntityImplCopyWithImpl<_$MenuItemEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _MenuItemEntity implements MenuItemEntity {
  const factory _MenuItemEntity({
    final String id,
    required final String name,
    required final String description,
    required final double price,
    required final String category,
    final String? imageUrl,
    required final bool isAvailable,
    required final int stock,
  }) = _$MenuItemEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  double get price;
  @override
  String get category;
  @override
  String? get imageUrl;
  @override
  bool get isAvailable;
  @override
  int get stock;

  /// Create a copy of MenuItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MenuItemEntityImplCopyWith<_$MenuItemEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
