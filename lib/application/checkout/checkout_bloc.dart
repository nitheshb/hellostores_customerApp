

import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/model/response/delivery_point_response.dart';
import 'package:goshops/infrastructure/model/response/payments_response.dart';
import 'package:goshops/infrastructure/model/response/user_address_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'checkout_event.dart';

part 'checkout_state.dart';

part 'checkout_bloc.freezed.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  int page = 0;
  int addressPage = 0;

  CheckoutBloc() : super(const CheckoutState()) {
    on<SelectAddress>(selectAddress);

    on<DeleteAddress>(deleteAddress);

    on<FetchUserAddress>(fetchUserAddress);

    on<ChangeActive>(changeActive);

    on<ChangeStep>(changeStep);

    on<SetMapController>(setMapController);

    on<SelectPoint>(selectPoint);

    on<FetchDeliveryPoint>(fetchDeliveryPoint);

    on<FetchDeliveryPrice>(fetchDeliveryPrice);

    on<FetchPayments>(fetchPayments);

    on<ChangePayment>(changePayment);

    on<ChangeDate>(changeDate);
  }

  selectAddress(event, emit) async {
    emit(state.copyWith(selectAddress: event.index));
  }

  deleteAddress(event, emit) async {
    List<UserAddress> list = List.from(state.address);
    list.removeAt(event.index);
    emit(state.copyWith(address: list));
    final res =
        await addressRepository.deleteAddress(addressId: event.addressId);
    res.fold((l) {}, (r) {
      emit(state.copyWith(isLoading: false));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  fetchUserAddress(event, emit) async {
    if (event.isRefresh ?? false) {
      event.controller?.resetNoData();
      addressPage = 0;
      emit(state.copyWith(address: [], isLoading: true));
    }
    final res = await addressRepository.getUserAddress(page: ++addressPage);
    res.fold((l) {
      List<UserAddress> list = List.from(state.address);
      list.addAll(l.data ?? []);
      emit(state.copyWith(isLoading: false, address: list));
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
      emit(state.copyWith(isLoading: false));
      if (event.isRefresh ?? false) {
        event.controller?.refreshFailed();
      }
      event.controller?.loadFailed();

      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  changeActive(event, emit) {
    emit(state.copyWith(isActive: event.active));
  }

  changeStep(event, emit) {
    if (event.step != null) {
      emit(state.copyWith(step: event.step ?? 1));
      return;
    }
    if (state.step == 3) {
      return;
    }
    emit(state.copyWith(step: state.step + 1));
  }

  setMapController(event, emit) {
    emit(state.copyWith(mapController: event.controller));
  }

  selectPoint(event, emit) {
    emit(state.copyWith(
      selectPointId: event.point?.id ?? 0,
    ));
  }

  fetchDeliveryPoint(event, emit) async {
    if (event.isRefresh ?? false) {
      event.controller?.resetNoData();
      page = 0;
      emit(state.copyWith(deliveryPoints: [], isLoadingPoint: true));
    }
    final res = await addressRepository.getDeliveryPoint(page: ++page);
    res.fold((l) {
      List<DeliveryPoint> list = List.from(state.deliveryPoints ?? []);
      list.addAll(l.data ?? []);
      emit(state.copyWith(
          isLoadingPoint: false,
          deliveryPoints: list,
          selectPointId: list.isNotEmpty ? (list.first.id ?? 0) : -1));
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
      emit(state.copyWith(isLoadingPoint: false));
      if (event.isRefresh ?? false) {
        event.controller?.refreshFailed();
      }
      event.controller?.loadFailed();

      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  fetchDeliveryPrice(event, emit) async {
    emit(state.copyWith(deliveryPrice: []));
    final response = await addressRepository.getDeliveryPrice();
    response.fold((l) {
      emit(state.copyWith(isLoadingPoint: false, deliveryPrice: l.data));
    }, (r) {
      emit(state.copyWith(isLoadingPoint: false));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  fetchPayments(event, emit) async {
    final res = await paymentsRepository.getPayments();
    res.fold((l) {
      int index = 0;
      for (int i = 0; i < (l.data?.length ?? 0); i++) {
        if (l.data?[i].tag == "cash") {
          index = i;
        }
      }
      emit(state.copyWith(list: l.data, selectId: l.data?[index].id ?? -1));
    }, (r) {
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  changePayment(event, emit) async {
    emit(state.copyWith(selectId: event.id));
  }

  changeDate(event, emit) async {
    emit(state.copyWith(deliveryDate: event.date));
  }
}
