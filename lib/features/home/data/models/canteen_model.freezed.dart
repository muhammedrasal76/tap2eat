// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'canteen_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CanteenModel _$CanteenModelFromJson(Map<String, dynamic> json) {
  return _CanteenModel.fromJson(json);
}

/// @nodoc
mixin _$CanteenModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(
    name: 'menu_items',
    fromJson: _menuItemsFromJson,
    toJson: _menuItemsToJson,
  )
  List<MenuItemModel> get menuItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_concurrent_orders')
  int get maxConcurrentOrders => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this CanteenModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CanteenModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CanteenModelCopyWith<CanteenModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CanteenModelCopyWith<$Res> {
  factory $CanteenModelCopyWith(
    CanteenModel value,
    $Res Function(CanteenModel) then,
  ) = _$CanteenModelCopyWithImpl<$Res, CanteenModel>;
  @useResult
  $Res call({
    String id,
    String name,
    @JsonKey(
      name: 'menu_items',
      fromJson: _menuItemsFromJson,
      toJson: _menuItemsToJson,
    )
    List<MenuItemModel> menuItems,
    @JsonKey(name: 'max_concurrent_orders') int maxConcurrentOrders,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class _$CanteenModelCopyWithImpl<$Res, $Val extends CanteenModel>
    implements $CanteenModelCopyWith<$Res> {
  _$CanteenModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CanteenModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? menuItems = null,
    Object? maxConcurrentOrders = null,
    Object? isActive = null,
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
                      as List<MenuItemModel>,
            maxConcurrentOrders: null == maxConcurrentOrders
                ? _value.maxConcurrentOrders
                : maxConcurrentOrders // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$CanteenModelImplCopyWith<$Res>
    implements $CanteenModelCopyWith<$Res> {
  factory _$$CanteenModelImplCopyWith(
    _$CanteenModelImpl value,
    $Res Function(_$CanteenModelImpl) then,
  ) = __$$CanteenModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    @JsonKey(
      name: 'menu_items',
      fromJson: _menuItemsFromJson,
      toJson: _menuItemsToJson,
    )
    List<MenuItemModel> menuItems,
    @JsonKey(name: 'max_concurrent_orders') int maxConcurrentOrders,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class __$$CanteenModelImplCopyWithImpl<$Res>
    extends _$CanteenModelCopyWithImpl<$Res, _$CanteenModelImpl>
    implements _$$CanteenModelImplCopyWith<$Res> {
  __$$CanteenModelImplCopyWithImpl(
    _$CanteenModelImpl _value,
    $Res Function(_$CanteenModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CanteenModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? menuItems = null,
    Object? maxConcurrentOrders = null,
    Object? isActive = null,
  }) {
    return _then(
      _$CanteenModelImpl(
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
                  as List<MenuItemModel>,
        maxConcurrentOrders: null == maxConcurrentOrders
            ? _value.maxConcurrentOrders
            : maxConcurrentOrders // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$CanteenModelImpl extends _CanteenModel {
  const _$CanteenModelImpl({
    required this.id,
    required this.name,
    @JsonKey(
      name: 'menu_items',
      fromJson: _menuItemsFromJson,
      toJson: _menuItemsToJson,
    )
    final List<MenuItemModel> menuItems = const [],
    @JsonKey(name: 'max_concurrent_orders') this.maxConcurrentOrders = 10,
    @JsonKey(name: 'is_active') this.isActive = true,
  }) : _menuItems = menuItems,
       super._();

  factory _$CanteenModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CanteenModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final List<MenuItemModel> _menuItems;
  @override
  @JsonKey(
    name: 'menu_items',
    fromJson: _menuItemsFromJson,
    toJson: _menuItemsToJson,
  )
  List<MenuItemModel> get menuItems {
    if (_menuItems is EqualUnmodifiableListView) return _menuItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_menuItems);
  }

  @override
  @JsonKey(name: 'max_concurrent_orders')
  final int maxConcurrentOrders;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'CanteenModel(id: $id, name: $name, menuItems: $menuItems, maxConcurrentOrders: $maxConcurrentOrders, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CanteenModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(
              other._menuItems,
              _menuItems,
            ) &&
            (identical(other.maxConcurrentOrders, maxConcurrentOrders) ||
                other.maxConcurrentOrders == maxConcurrentOrders) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    const DeepCollectionEquality().hash(_menuItems),
    maxConcurrentOrders,
    isActive,
  );

  /// Create a copy of CanteenModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CanteenModelImplCopyWith<_$CanteenModelImpl> get copyWith =>
      __$$CanteenModelImplCopyWithImpl<_$CanteenModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CanteenModelImplToJson(this);
  }
}

abstract class _CanteenModel extends CanteenModel {
  const factory _CanteenModel({
    required final String id,
    required final String name,
    @JsonKey(
      name: 'menu_items',
      fromJson: _menuItemsFromJson,
      toJson: _menuItemsToJson,
    )
    final List<MenuItemModel> menuItems,
    @JsonKey(name: 'max_concurrent_orders') final int maxConcurrentOrders,
    @JsonKey(name: 'is_active') final bool isActive,
  }) = _$CanteenModelImpl;
  const _CanteenModel._() : super._();

  factory _CanteenModel.fromJson(Map<String, dynamic> json) =
      _$CanteenModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(
    name: 'menu_items',
    fromJson: _menuItemsFromJson,
    toJson: _menuItemsToJson,
  )
  List<MenuItemModel> get menuItems;
  @override
  @JsonKey(name: 'max_concurrent_orders')
  int get maxConcurrentOrders;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of CanteenModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CanteenModelImplCopyWith<_$CanteenModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
