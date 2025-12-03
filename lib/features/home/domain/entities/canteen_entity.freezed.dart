// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'canteen_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CanteenEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<MenuItemEntity> get menuItems => throw _privateConstructorUsedError;
  int get maxConcurrentOrders => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Create a copy of CanteenEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CanteenEntityCopyWith<CanteenEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CanteenEntityCopyWith<$Res> {
  factory $CanteenEntityCopyWith(
    CanteenEntity value,
    $Res Function(CanteenEntity) then,
  ) = _$CanteenEntityCopyWithImpl<$Res, CanteenEntity>;
  @useResult
  $Res call({
    String id,
    String name,
    List<MenuItemEntity> menuItems,
    int maxConcurrentOrders,
    bool isActive,
    String? imageUrl,
  });
}

/// @nodoc
class _$CanteenEntityCopyWithImpl<$Res, $Val extends CanteenEntity>
    implements $CanteenEntityCopyWith<$Res> {
  _$CanteenEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CanteenEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? menuItems = null,
    Object? maxConcurrentOrders = null,
    Object? isActive = null,
    Object? imageUrl = freezed,
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
            menuItems: null == menuItems
                ? _value.menuItems
                : menuItems // ignore: cast_nullable_to_non_nullable
                      as List<MenuItemEntity>,
            maxConcurrentOrders: null == maxConcurrentOrders
                ? _value.maxConcurrentOrders
                : maxConcurrentOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$CanteenEntityImplCopyWith<$Res>
    implements $CanteenEntityCopyWith<$Res> {
  factory _$$CanteenEntityImplCopyWith(
    _$CanteenEntityImpl value,
    $Res Function(_$CanteenEntityImpl) then,
  ) = __$$CanteenEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    List<MenuItemEntity> menuItems,
    int maxConcurrentOrders,
    bool isActive,
    String? imageUrl,
  });
}

/// @nodoc
class __$$CanteenEntityImplCopyWithImpl<$Res>
    extends _$CanteenEntityCopyWithImpl<$Res, _$CanteenEntityImpl>
    implements _$$CanteenEntityImplCopyWith<$Res> {
  __$$CanteenEntityImplCopyWithImpl(
    _$CanteenEntityImpl _value,
    $Res Function(_$CanteenEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CanteenEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? menuItems = null,
    Object? maxConcurrentOrders = null,
    Object? isActive = null,
    Object? imageUrl = freezed,
  }) {
    return _then(
      _$CanteenEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        menuItems: null == menuItems
            ? _value._menuItems
            : menuItems // ignore: cast_nullable_to_non_nullable
                  as List<MenuItemEntity>,
        maxConcurrentOrders: null == maxConcurrentOrders
            ? _value.maxConcurrentOrders
            : maxConcurrentOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CanteenEntityImpl implements _CanteenEntity {
  const _$CanteenEntityImpl({
    required this.id,
    required this.name,
    required final List<MenuItemEntity> menuItems,
    required this.maxConcurrentOrders,
    required this.isActive,
    this.imageUrl,
  }) : _menuItems = menuItems;

  @override
  final String id;
  @override
  final String name;
  final List<MenuItemEntity> _menuItems;
  @override
  List<MenuItemEntity> get menuItems {
    if (_menuItems is EqualUnmodifiableListView) return _menuItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_menuItems);
  }

  @override
  final int maxConcurrentOrders;
  @override
  final bool isActive;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'CanteenEntity(id: $id, name: $name, menuItems: $menuItems, maxConcurrentOrders: $maxConcurrentOrders, isActive: $isActive, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CanteenEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(
              other._menuItems,
              _menuItems,
            ) &&
            (identical(other.maxConcurrentOrders, maxConcurrentOrders) ||
                other.maxConcurrentOrders == maxConcurrentOrders) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    const DeepCollectionEquality().hash(_menuItems),
    maxConcurrentOrders,
    isActive,
    imageUrl,
  );

  /// Create a copy of CanteenEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CanteenEntityImplCopyWith<_$CanteenEntityImpl> get copyWith =>
      __$$CanteenEntityImplCopyWithImpl<_$CanteenEntityImpl>(this, _$identity);
}

abstract class _CanteenEntity implements CanteenEntity {
  const factory _CanteenEntity({
    required final String id,
    required final String name,
    required final List<MenuItemEntity> menuItems,
    required final int maxConcurrentOrders,
    required final bool isActive,
    final String? imageUrl,
  }) = _$CanteenEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  List<MenuItemEntity> get menuItems;
  @override
  int get maxConcurrentOrders;
  @override
  bool get isActive;
  @override
  String? get imageUrl;

  /// Create a copy of CanteenEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CanteenEntityImplCopyWith<_$CanteenEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
