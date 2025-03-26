import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/model/model/order_model.dart';
import 'package:goshops/infrastructure/model/model/parcel_order_model.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/service//marker_image_cropper.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/maps_list.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'package:map_launcher/map_launcher.dart';

part 'drawing_route_event.dart';

part 'drawing_route_state.dart';

part 'drawing_route_bloc.freezed.dart';

class DrawingRouteBloc extends Bloc<DrawingRouteEvent, DrawingRouteState> {
  DrawingRouteBloc() : super(const DrawingRouteState()) {
    on<GetRoutingAll>(getRoutingAll);

    on<SetMarkers>(setMarkers);
  }

  getRoutingAll(GetRoutingAll event, emit) async {
    final LatLng start;
    final LatLng end;
    if (event.parcel != null) {
      start = LatLng(
          event.parcel?.addressFrom?.latitude ??
              AppHelpers.getInitialLatitude(),
          event.parcel?.addressFrom?.longitude ??
              AppHelpers.getInitialLongitude());

      end = LatLng(
          event.parcel?.addressTo?.latitude ?? AppHelpers.getInitialLatitude(),
          event.parcel?.addressTo?.longitude ??
              AppHelpers.getInitialLongitude());
    } else if (event.order?.deliveryType == "point") {
      return;
    } else {
      start = LatLng(
        LocalStorage.getWareHouse().location?.latitude ??
            AppHelpers.getInitialLatitude(),
        LocalStorage.getWareHouse().location?.longitude ??
            AppHelpers.getInitialLongitude(),
      );

      end = LatLng(
        event.order?.address?.location?.latitude ??
            AppHelpers.getInitialLatitude(),
        event.order?.address?.location?.longitude ??
            AppHelpers.getInitialLongitude(),
      );
    }

    emit(state.copyWith(polylineCoordinates: [], isLoading: true));
    final response = await addressRepository.getRouting(start: start, end: end);
    response.fold(
      (l) {
        List<LatLng> list = [];
        List ls = l.features[0].geometry.coordinates;
        for (int i = 0; i < ls.length; i++) {
          list.add(LatLng(ls[i][1], ls[i][0]));
        }
        emit(state.copyWith(polylineCoordinates: list, isLoading: false));
      },
      (r) => emit(
        state.copyWith(polylineCoordinates: [], isLoading: false),
      ),
    );
  }

  setMarkers(SetMarkers event, emit) async {
    final ImageCropperForMarker image = ImageCropperForMarker();
    if (event.parcel != null) {
      Map<MarkerId, Marker> list = {
        MarkerId(AppHelpers.getAppName()): Marker(
            onTap: () {
              AppHelpers.showCustomModalBottomSheet(
                  context: event.context,
                  modal: Container(
                    padding: EdgeInsets.only(top: 32.r),
                    decoration: BoxDecoration(
                      color: event.colors.backgroundColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(AppConstants.radius.r),
                        topLeft: Radius.circular(AppConstants.radius.r),
                      ),
                    ),
                    child: MapsList(
                        colors: event.colors,
                        location: Coords(
                            event.parcel?.addressFrom?.latitude ??
                                AppHelpers.getInitialLatitude(),
                            event.parcel?.addressFrom?.longitude ??
                                AppHelpers.getInitialLongitude()),
                        title: AppHelpers.getAppName()),
                  ));
            },
            markerId: MarkerId(AppHelpers.getAppName()),
            position: LatLng(
              event.parcel?.addressFrom?.latitude ??
                  AppHelpers.getInitialLatitude(),
              event.parcel?.addressFrom?.longitude ??
                  AppHelpers.getInitialLongitude(),
            ),
            icon: await image.resizeAndCircle(
                LocalStorage.getUser().img ?? "", 60.r)),
        const MarkerId("Githubit"): Marker(
          markerId: const MarkerId("Githubit"),
          onTap: () {
            AppHelpers.showCustomModalBottomSheet(
                context: event.context,
                modal: Container(
                  padding: EdgeInsets.only(top: 32.r),
                  decoration: BoxDecoration(
                    color: event.colors.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(AppConstants.radius.r),
                      topLeft: Radius.circular(AppConstants.radius.r),
                    ),
                  ),
                  child: MapsList(
                      colors: event.colors,
                      location: Coords(
                          event.parcel?.addressTo?.latitude ??
                              AppHelpers.getInitialLatitude(),
                          event.parcel?.addressTo?.longitude ??
                              AppHelpers.getInitialLongitude()),
                      title: "Githubit"),
                ));
          },
          position: LatLng(
            event.parcel?.addressTo?.latitude ??
                AppHelpers.getInitialLatitude(),
            event.parcel?.addressTo?.longitude ??
                AppHelpers.getInitialLongitude(),
          ),
          icon: await image.resizeAndCircle("", 60.r),
        ),
      };
      emit(state.copyWith(markers: list));
      return;
    }
    if (event.order?.deliveryType == "point") {
      Map<MarkerId, Marker> list = {
        const MarkerId("User"): Marker(
            markerId: const MarkerId("User"),
            onTap: () {
              AppHelpers.showCustomModalBottomSheet(
                  context: event.context,
                  modal: Container(
                    padding: EdgeInsets.only(top: 32.r),
                    decoration: BoxDecoration(
                      color: event.colors.backgroundColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(AppConstants.radius.r),
                        topLeft: Radius.circular(AppConstants.radius.r),
                      ),
                    ),
                    child: MapsList(
                        colors: event.colors,
                        location: Coords(
                            event.order?.deliveryPoint?.location?.latitude ??
                                AppHelpers.getInitialLatitude(),
                            event.order?.deliveryPoint?.location?.longitude ??
                                AppHelpers.getInitialLongitude()),
                        title: "User"),
                  ));
            },
            position: LatLng(
              event.order?.deliveryPoint?.location?.latitude ??
                  AppHelpers.getInitialLatitude(),
              event.order?.deliveryPoint?.location?.longitude ??
                  AppHelpers.getInitialLongitude(),
            ),
            icon: await image.resizeAndCircle("", 60.r)),
      };
      emit(state.copyWith(markers: list));
      return;
    }
    Map<MarkerId, Marker> list = {
      MarkerId(AppHelpers.getAppName()): Marker(
          markerId: MarkerId(AppHelpers.getAppName()),
          onTap: () {
            AppHelpers.showCustomModalBottomSheet(
                context: event.context,
                modal: Container(
                  padding: EdgeInsets.only(top: 32.r),
                  decoration: BoxDecoration(
                    color: event.colors.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(AppConstants.radius.r),
                      topLeft: Radius.circular(AppConstants.radius.r),
                    ),
                  ),
                  child: MapsList(
                      colors: event.colors,
                      location: Coords(
                        event.order?.type == 1
                            ? LocalStorage.getWareHouse().location?.latitude ??
                                AppHelpers.getInitialLatitude()
                            : event.order?.shop?.location?.latitude ??
                                AppHelpers.getInitialLatitude(),
                        event.order?.type == 1
                            ? LocalStorage.getWareHouse().location?.longitude ??
                                AppHelpers.getInitialLongitude()
                            : event.order?.shop?.location?.longitude ??
                                AppHelpers.getInitialLongitude(),
                      ),
                      title: AppHelpers.getAppName()),
                ));
          },
          position: LatLng(
            event.order?.type == 1
                ? LocalStorage.getWareHouse().location?.latitude ??
                    AppHelpers.getInitialLatitude()
                : event.order?.shop?.location?.latitude ??
                    AppHelpers.getInitialLatitude(),
            event.order?.type == 1
                ? LocalStorage.getWareHouse().location?.longitude ??
                    AppHelpers.getInitialLongitude()
                : event.order?.shop?.location?.longitude ??
                    AppHelpers.getInitialLongitude(),
          ),
          icon: await image.resizeAndCircle(
              LocalStorage.getWareHouse().img ?? "", 60.r)),
      const MarkerId("User"): Marker(
          markerId: const MarkerId("User"),
          onTap: () {
            AppHelpers.showCustomModalBottomSheet(
                context: event.context,
                modal: Container(
                  padding: EdgeInsets.only(top: 32.r),
                  decoration: BoxDecoration(
                    color: event.colors.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(AppConstants.radius.r),
                      topLeft: Radius.circular(AppConstants.radius.r),
                    ),
                  ),
                  child: MapsList(
                      colors: event.colors,
                      location: Coords(
                        event.order?.address?.location?.latitude ??
                            AppHelpers.getInitialLatitude(),
                        event.order?.address?.location?.longitude ??
                            AppHelpers.getInitialLongitude(),
                      ),
                      title: "User"),
                ));
          },
          position: LatLng(
            event.order?.address?.location?.latitude ??
                AppHelpers.getInitialLatitude(),
            event.order?.address?.location?.longitude ??
                AppHelpers.getInitialLongitude(),
          ),
          icon: await image.resizeAndCircle(
              LocalStorage.getUser().img ?? "", 60.r)),
    };
    emit(state.copyWith(markers: list));
  }
}
