// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShopEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BuildContext context, bool? isRefresh,
            RefreshController? controller)
        fetchShops,
    required TResult Function(BuildContext context, ShopData? shop)
        fetchShopById,
    required TResult Function() fetchMarkers,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BuildContext context, bool? isRefresh,
            RefreshController? controller)?
        fetchShops,
    TResult? Function(BuildContext context, ShopData? shop)? fetchShopById,
    TResult? Function()? fetchMarkers,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuildContext context, bool? isRefresh,
            RefreshController? controller)?
        fetchShops,
    TResult Function(BuildContext context, ShopData? shop)? fetchShopById,
    TResult Function()? fetchMarkers,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchShops value) fetchShops,
    required TResult Function(FetchShopById value) fetchShopById,
    required TResult Function(FetchMarkers value) fetchMarkers,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchShops value)? fetchShops,
    TResult? Function(FetchShopById value)? fetchShopById,
    TResult? Function(FetchMarkers value)? fetchMarkers,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchShops value)? fetchShops,
    TResult Function(FetchShopById value)? fetchShopById,
    TResult Function(FetchMarkers value)? fetchMarkers,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopEventCopyWith<$Res> {
  factory $ShopEventCopyWith(ShopEvent value, $Res Function(ShopEvent) then) =
      _$ShopEventCopyWithImpl<$Res, ShopEvent>;
}

/// @nodoc
class _$ShopEventCopyWithImpl<$Res, $Val extends ShopEvent>
    implements $ShopEventCopyWith<$Res> {
  _$ShopEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShopEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FetchShopsImplCopyWith<$Res> {
  factory _$$FetchShopsImplCopyWith(
          _$FetchShopsImpl value, $Res Function(_$FetchShopsImpl) then) =
      __$$FetchShopsImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {BuildContext context, bool? isRefresh, RefreshController? controller});
}

/// @nodoc
class __$$FetchShopsImplCopyWithImpl<$Res>
    extends _$ShopEventCopyWithImpl<$Res, _$FetchShopsImpl>
    implements _$$FetchShopsImplCopyWith<$Res> {
  __$$FetchShopsImplCopyWithImpl(
      _$FetchShopsImpl _value, $Res Function(_$FetchShopsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShopEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? context = null,
    Object? isRefresh = freezed,
    Object? controller = freezed,
  }) {
    return _then(_$FetchShopsImpl(
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as BuildContext,
      isRefresh: freezed == isRefresh
          ? _value.isRefresh
          : isRefresh // ignore: cast_nullable_to_non_nullable
              as bool?,
      controller: freezed == controller
          ? _value.controller
          : controller // ignore: cast_nullable_to_non_nullable
              as RefreshController?,
    ));
  }
}

/// @nodoc

class _$FetchShopsImpl implements FetchShops {
  const _$FetchShopsImpl(
      {required this.context, this.isRefresh, this.controller});

  @override
  final BuildContext context;
  @override
  final bool? isRefresh;
  @override
  final RefreshController? controller;

  @override
  String toString() {
    return 'ShopEvent.fetchShops(context: $context, isRefresh: $isRefresh, controller: $controller)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FetchShopsImpl &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.isRefresh, isRefresh) ||
                other.isRefresh == isRefresh) &&
            (identical(other.controller, controller) ||
                other.controller == controller));
  }

  @override
  int get hashCode => Object.hash(runtimeType, context, isRefresh, controller);

  /// Create a copy of ShopEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FetchShopsImplCopyWith<_$FetchShopsImpl> get copyWith =>
      __$$FetchShopsImplCopyWithImpl<_$FetchShopsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BuildContext context, bool? isRefresh,
            RefreshController? controller)
        fetchShops,
    required TResult Function(BuildContext context, ShopData? shop)
        fetchShopById,
    required TResult Function() fetchMarkers,
  }) {
    return fetchShops(context, isRefresh, controller);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BuildContext context, bool? isRefresh,
            RefreshController? controller)?
        fetchShops,
    TResult? Function(BuildContext context, ShopData? shop)? fetchShopById,
    TResult? Function()? fetchMarkers,
  }) {
    return fetchShops?.call(context, isRefresh, controller);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuildContext context, bool? isRefresh,
            RefreshController? controller)?
        fetchShops,
    TResult Function(BuildContext context, ShopData? shop)? fetchShopById,
    TResult Function()? fetchMarkers,
    required TResult orElse(),
  }) {
    if (fetchShops != null) {
      return fetchShops(context, isRefresh, controller);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchShops value) fetchShops,
    required TResult Function(FetchShopById value) fetchShopById,
    required TResult Function(FetchMarkers value) fetchMarkers,
  }) {
    return fetchShops(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchShops value)? fetchShops,
    TResult? Function(FetchShopById value)? fetchShopById,
    TResult? Function(FetchMarkers value)? fetchMarkers,
  }) {
    return fetchShops?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchShops value)? fetchShops,
    TResult Function(FetchShopById value)? fetchShopById,
    TResult Function(FetchMarkers value)? fetchMarkers,
    required TResult orElse(),
  }) {
    if (fetchShops != null) {
      return fetchShops(this);
    }
    return orElse();
  }
}

abstract class FetchShops implements ShopEvent {
  const factory FetchShops(
      {required final BuildContext context,
      final bool? isRefresh,
      final RefreshController? controller}) = _$FetchShopsImpl;

  BuildContext get context;
  bool? get isRefresh;
  RefreshController? get controller;

  /// Create a copy of ShopEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FetchShopsImplCopyWith<_$FetchShopsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FetchShopByIdImplCopyWith<$Res> {
  factory _$$FetchShopByIdImplCopyWith(
          _$FetchShopByIdImpl value, $Res Function(_$FetchShopByIdImpl) then) =
      __$$FetchShopByIdImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BuildContext context, ShopData? shop});
}

/// @nodoc
class __$$FetchShopByIdImplCopyWithImpl<$Res>
    extends _$ShopEventCopyWithImpl<$Res, _$FetchShopByIdImpl>
    implements _$$FetchShopByIdImplCopyWith<$Res> {
  __$$FetchShopByIdImplCopyWithImpl(
      _$FetchShopByIdImpl _value, $Res Function(_$FetchShopByIdImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShopEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? context = null,
    Object? shop = freezed,
  }) {
    return _then(_$FetchShopByIdImpl(
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as BuildContext,
      shop: freezed == shop
          ? _value.shop
          : shop // ignore: cast_nullable_to_non_nullable
              as ShopData?,
    ));
  }
}

/// @nodoc

class _$FetchShopByIdImpl implements FetchShopById {
  const _$FetchShopByIdImpl({required this.context, required this.shop});

  @override
  final BuildContext context;
  @override
  final ShopData? shop;

  @override
  String toString() {
    return 'ShopEvent.fetchShopById(context: $context, shop: $shop)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FetchShopByIdImpl &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.shop, shop) || other.shop == shop));
  }

  @override
  int get hashCode => Object.hash(runtimeType, context, shop);

  /// Create a copy of ShopEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FetchShopByIdImplCopyWith<_$FetchShopByIdImpl> get copyWith =>
      __$$FetchShopByIdImplCopyWithImpl<_$FetchShopByIdImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BuildContext context, bool? isRefresh,
            RefreshController? controller)
        fetchShops,
    required TResult Function(BuildContext context, ShopData? shop)
        fetchShopById,
    required TResult Function() fetchMarkers,
  }) {
    return fetchShopById(context, shop);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BuildContext context, bool? isRefresh,
            RefreshController? controller)?
        fetchShops,
    TResult? Function(BuildContext context, ShopData? shop)? fetchShopById,
    TResult? Function()? fetchMarkers,
  }) {
    return fetchShopById?.call(context, shop);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuildContext context, bool? isRefresh,
            RefreshController? controller)?
        fetchShops,
    TResult Function(BuildContext context, ShopData? shop)? fetchShopById,
    TResult Function()? fetchMarkers,
    required TResult orElse(),
  }) {
    if (fetchShopById != null) {
      return fetchShopById(context, shop);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchShops value) fetchShops,
    required TResult Function(FetchShopById value) fetchShopById,
    required TResult Function(FetchMarkers value) fetchMarkers,
  }) {
    return fetchShopById(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchShops value)? fetchShops,
    TResult? Function(FetchShopById value)? fetchShopById,
    TResult? Function(FetchMarkers value)? fetchMarkers,
  }) {
    return fetchShopById?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchShops value)? fetchShops,
    TResult Function(FetchShopById value)? fetchShopById,
    TResult Function(FetchMarkers value)? fetchMarkers,
    required TResult orElse(),
  }) {
    if (fetchShopById != null) {
      return fetchShopById(this);
    }
    return orElse();
  }
}

abstract class FetchShopById implements ShopEvent {
  const factory FetchShopById(
      {required final BuildContext context,
      required final ShopData? shop}) = _$FetchShopByIdImpl;

  BuildContext get context;
  ShopData? get shop;

  /// Create a copy of ShopEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FetchShopByIdImplCopyWith<_$FetchShopByIdImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FetchMarkersImplCopyWith<$Res> {
  factory _$$FetchMarkersImplCopyWith(
          _$FetchMarkersImpl value, $Res Function(_$FetchMarkersImpl) then) =
      __$$FetchMarkersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FetchMarkersImplCopyWithImpl<$Res>
    extends _$ShopEventCopyWithImpl<$Res, _$FetchMarkersImpl>
    implements _$$FetchMarkersImplCopyWith<$Res> {
  __$$FetchMarkersImplCopyWithImpl(
      _$FetchMarkersImpl _value, $Res Function(_$FetchMarkersImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShopEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FetchMarkersImpl implements FetchMarkers {
  const _$FetchMarkersImpl();

  @override
  String toString() {
    return 'ShopEvent.fetchMarkers()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FetchMarkersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BuildContext context, bool? isRefresh,
            RefreshController? controller)
        fetchShops,
    required TResult Function(BuildContext context, ShopData? shop)
        fetchShopById,
    required TResult Function() fetchMarkers,
  }) {
    return fetchMarkers();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BuildContext context, bool? isRefresh,
            RefreshController? controller)?
        fetchShops,
    TResult? Function(BuildContext context, ShopData? shop)? fetchShopById,
    TResult? Function()? fetchMarkers,
  }) {
    return fetchMarkers?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BuildContext context, bool? isRefresh,
            RefreshController? controller)?
        fetchShops,
    TResult Function(BuildContext context, ShopData? shop)? fetchShopById,
    TResult Function()? fetchMarkers,
    required TResult orElse(),
  }) {
    if (fetchMarkers != null) {
      return fetchMarkers();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchShops value) fetchShops,
    required TResult Function(FetchShopById value) fetchShopById,
    required TResult Function(FetchMarkers value) fetchMarkers,
  }) {
    return fetchMarkers(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchShops value)? fetchShops,
    TResult? Function(FetchShopById value)? fetchShopById,
    TResult? Function(FetchMarkers value)? fetchMarkers,
  }) {
    return fetchMarkers?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchShops value)? fetchShops,
    TResult Function(FetchShopById value)? fetchShopById,
    TResult Function(FetchMarkers value)? fetchMarkers,
    required TResult orElse(),
  }) {
    if (fetchMarkers != null) {
      return fetchMarkers(this);
    }
    return orElse();
  }
}

abstract class FetchMarkers implements ShopEvent {
  const factory FetchMarkers() = _$FetchMarkersImpl;
}

/// @nodoc
mixin _$ShopState {
  List<ShopData> get shops => throw _privateConstructorUsedError;
  ShopData? get shop => throw _privateConstructorUsedError;
  bool get isLoadingoshopss => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  Map<MarkerId, Marker> get shopMarkers => throw _privateConstructorUsedError;

  /// Create a copy of ShopState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShopStateCopyWith<ShopState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopStateCopyWith<$Res> {
  factory $ShopStateCopyWith(ShopState value, $Res Function(ShopState) then) =
      _$ShopStateCopyWithImpl<$Res, ShopState>;
  @useResult
  $Res call(
      {List<ShopData> shops,
      ShopData? shop,
      bool isLoadingoshopss,
      bool isLoading,
      Map<MarkerId, Marker> shopMarkers});
}

/// @nodoc
class _$ShopStateCopyWithImpl<$Res, $Val extends ShopState>
    implements $ShopStateCopyWith<$Res> {
  _$ShopStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShopState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shops = null,
    Object? shop = freezed,
    Object? isLoadingoshopss = null,
    Object? isLoading = null,
    Object? shopMarkers = null,
  }) {
    return _then(_value.copyWith(
      shops: null == shops
          ? _value.shops
          : shops // ignore: cast_nullable_to_non_nullable
              as List<ShopData>,
      shop: freezed == shop
          ? _value.shop
          : shop // ignore: cast_nullable_to_non_nullable
              as ShopData?,
      isLoadingoshopss: null == isLoadingoshopss
          ? _value.isLoadingoshopss
          : isLoadingoshopss // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      shopMarkers: null == shopMarkers
          ? _value.shopMarkers
          : shopMarkers // ignore: cast_nullable_to_non_nullable
              as Map<MarkerId, Marker>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShopStateImplCopyWith<$Res>
    implements $ShopStateCopyWith<$Res> {
  factory _$$ShopStateImplCopyWith(
          _$ShopStateImpl value, $Res Function(_$ShopStateImpl) then) =
      __$$ShopStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ShopData> shops,
      ShopData? shop,
      bool isLoadingoshopss,
      bool isLoading,
      Map<MarkerId, Marker> shopMarkers});
}

/// @nodoc
class __$$ShopStateImplCopyWithImpl<$Res>
    extends _$ShopStateCopyWithImpl<$Res, _$ShopStateImpl>
    implements _$$ShopStateImplCopyWith<$Res> {
  __$$ShopStateImplCopyWithImpl(
      _$ShopStateImpl _value, $Res Function(_$ShopStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShopState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shops = null,
    Object? shop = freezed,
    Object? isLoadingoshopss = null,
    Object? isLoading = null,
    Object? shopMarkers = null,
  }) {
    return _then(_$ShopStateImpl(
      shops: null == shops
          ? _value._shops
          : shops // ignore: cast_nullable_to_non_nullable
              as List<ShopData>,
      shop: freezed == shop
          ? _value.shop
          : shop // ignore: cast_nullable_to_non_nullable
              as ShopData?,
      isLoadingoshopss: null == isLoadingoshopss
          ? _value.isLoadingoshopss
          : isLoadingoshopss // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      shopMarkers: null == shopMarkers
          ? _value._shopMarkers
          : shopMarkers // ignore: cast_nullable_to_non_nullable
              as Map<MarkerId, Marker>,
    ));
  }
}

/// @nodoc

class _$ShopStateImpl implements _ShopState {
  const _$ShopStateImpl(
      {final List<ShopData> shops = const [],
      this.shop = null,
      this.isLoadingoshopss = true,
      this.isLoading = true,
      final Map<MarkerId, Marker> shopMarkers = const {}})
      : _shops = shops,
        _shopMarkers = shopMarkers;

  final List<ShopData> _shops;
  @override
  @JsonKey()
  List<ShopData> get shops {
    if (_shops is EqualUnmodifiableListView) return _shops;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shops);
  }

  @override
  @JsonKey()
  final ShopData? shop;
  @override
  @JsonKey()
  final bool isLoadingoshopss;
  @override
  @JsonKey()
  final bool isLoading;
  final Map<MarkerId, Marker> _shopMarkers;
  @override
  @JsonKey()
  Map<MarkerId, Marker> get shopMarkers {
    if (_shopMarkers is EqualUnmodifiableMapView) return _shopMarkers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_shopMarkers);
  }

  @override
  String toString() {
    return 'ShopState(shops: $shops, shop: $shop, isLoadingoshopss: $isLoadingoshopss, isLoading: $isLoading, shopMarkers: $shopMarkers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopStateImpl &&
            const DeepCollectionEquality().equals(other._shops, _shops) &&
            (identical(other.shop, shop) || other.shop == shop) &&
            (identical(other.isLoadingoshopss, isLoadingoshopss) ||
                other.isLoadingoshopss == isLoadingoshopss) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._shopMarkers, _shopMarkers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_shops),
      shop,
      isLoadingoshopss,
      isLoading,
      const DeepCollectionEquality().hash(_shopMarkers));

  /// Create a copy of ShopState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopStateImplCopyWith<_$ShopStateImpl> get copyWith =>
      __$$ShopStateImplCopyWithImpl<_$ShopStateImpl>(this, _$identity);
}

abstract class _ShopState implements ShopState {
  const factory _ShopState(
      {final List<ShopData> shops,
      final ShopData? shop,
      final bool isLoadingoshopss,
      final bool isLoading,
      final Map<MarkerId, Marker> shopMarkers}) = _$ShopStateImpl;

  @override
  List<ShopData> get shops;
  @override
  ShopData? get shop;
  @override
  bool get isLoadingoshopss;
  @override
  bool get isLoading;
  @override
  Map<MarkerId, Marker> get shopMarkers;

  /// Create a copy of ShopState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShopStateImplCopyWith<_$ShopStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
