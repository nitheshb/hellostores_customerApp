import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/model/model/shop_model.dart';
import 'package:goshops/infrastructure/service/marker_image_cropper.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'shop_event.dart';

part 'shop_state.dart';

part 'shop_bloc.freezed.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  int page = 0;

  ShopBloc() : super(const ShopState()) {
    on<FetchShops>(fetchShops);
    on<FetchShopById>(fetchShopById);
    on<FetchMarkers>(fetchMarkers);
  }

  fetchShops(event, emit) async {
    if (event.isRefresh ?? false) {
      event.controller?.resetNoData();
      page = 0;
      emit(state.copyWith(shops: [], isLoadingoshopss: true));
    }
    final res = await shopsRepository.getAllShops(page: ++page);
    res.fold((l) {
      List<ShopData> list = List.from(state.shops);
      list.addAll(l.data ?? []);
      emit(state.copyWith(isLoadingoshopss: false, shops: list));
      add(const ShopEvent.fetchMarkers());
      if (event.isRefresh ?? false) {
        event.controller?.refreshCompleted();
        return;
      } else if (l.data?.isEmpty ?? true) {
        event.controller?.loadNoData();
        return;
      }
      event.controller?.loadComplete();
      return;
    }, (r) {
      emit(state.copyWith(isLoadingoshopss: false));
      if (event.isRefresh ?? false) {
        event.controller?.refreshFailed();
      }
      event.controller?.loadFailed();
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  fetchShopById(event, emit) async {
    emit(state.copyWith(shop: event.shop, isLoading: true));
    final res = await shopsRepository.getSingleShop(event.shop?.uuid ?? "");
    res.fold((l) {
      emit(state.copyWith(isLoading: false, shop: l.data));
    }, (r) {
      emit(state.copyWith(isLoading: false));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  fetchMarkers(event, emit) async {
    final ImageCropperForMarker image = ImageCropperForMarker();
    for (int i = 0; i < state.shops.length; i++) {
      final MarkerId markerId = MarkerId('$i-${state.shops[i].id}');
      double latitude =
          state.shops[i].location?.latitude ?? AppHelpers.getInitialLatitude();
      double longitude = state.shops[i].location?.longitude ??
          AppHelpers.getInitialLongitude();
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(latitude, longitude),
        icon: await image.resizeAndCircle(state.shops[i].logoImg, 48),
        infoWindow: InfoWindow(
          title: state.shops[i].translation?.title?.toUpperCase(),
          snippet:
              '${AppHelpers.getTranslation(TrKeys.workingHours)}: ${AppHelpers.shopTime(state.shops[i].workingDays, state.shops[i].open)}',
        ),
      );
      final Map<MarkerId, Marker> markers = Map.from(state.shopMarkers);
      markers[markerId] = marker;
      emit(state.copyWith(shopMarkers: markers));
    }
  }
}
