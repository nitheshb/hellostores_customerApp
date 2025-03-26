

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/model/request/create_parcel_model.dart';
import 'package:goshops/infrastructure/model/model/location_model.dart';
import 'package:goshops/infrastructure/model/model/parcel_order_model.dart';
import 'package:goshops/infrastructure/model/response/parcel_calculate_response.dart';
import 'package:goshops/infrastructure/model/response/parcel_response.dart';
import 'package:goshops/infrastructure/model/response/payments_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

part 'parcel_event.dart';

part 'parcel_state.dart';

part 'parcel_bloc.freezed.dart';

class ParcelBloc extends Bloc<ParcelEvent, ParcelState> {
  ParcelBloc() : super(const ParcelState()) {
    on<AddReview>(addReview);

    on<ChangeExpand>(changeExpand);

    on<ChangeAnonymous>(changeAnonymous);

    on<FetchTypes>(fetchTypes);

    on<GetCalculate>(getCalculate);

    on<OrderParcel>(orderParcel);

    on<SelectType>(selectType);

    on<SetToAddress>(setToAddress);

    on<SetFromAddress>(setFromAddress);

    on<SwitchAddress>(switchAddress);

    on<SetTime>(setTime);

    on<ShowParcel>(showParcel);
  }

  addReview(event, emit) async {
    emit(state.copyWith(isButtonLoading: true));
    final response = await parcelRepository.addReview(state.parcel?.id ?? 0,
        rating: event.rating, comment: event.comment);
    response.fold((l) {
      emit(state.copyWith(isButtonLoading: false));
      Navigator.pop(event.context);
    }, (r) {
      emit(state.copyWith(isButtonLoading: false));
      AppHelpers.errorSnackBar(
        context: event.context,
        message: r,
      );
    });
  }

  changeExpand(event, emit) {
    emit(state.copyWith(expand: !state.expand));
  }

  changeAnonymous(event, emit) {
    emit(state.copyWith(anonymous: !state.anonymous));
  }

  fetchTypes(event, emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await parcelRepository.getTypes();
    response.fold(
        (l) => emit(state.copyWith(isLoading: false, types: l.data ?? [])),
        (r) {
      emit(state.copyWith(isLoading: false));
      AppHelpers.errorSnackBar(
        context: event.context,
        message: AppHelpers.getTranslation(r),
      );
    });
  }

  getCalculate(event, emit) async {
    emit(state.copyWith(isLoading: true, error: false));
    final response = await parcelRepository.getCalculate(
        typeId: state.types[state.selectType]?.id ?? 0,
        from: state.locationFrom ?? LocationModel(),
        to: state.locationTo ?? LocationModel());

    response.fold((l) => emit(state.copyWith(isLoading: false, calculate: l)),
        (r) {
      emit(state.copyWith(isLoading: false, error: true));
      AppHelpers.errorSnackBar(
        context: event.context,
        message: r,
      );
    });
  }

  orderParcel(event, emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await parcelRepository.orderParcel(
        parcel: CreateParcelModel(
      typeId: state.types[state.selectType]?.id ?? 0,
      from: state.locationFrom ?? LocationModel(),
      to: state.locationTo ?? LocationModel(),
      fromTitle: state.addressFrom ?? "",
      toTitle: state.addressTo ?? "",
      time:
          "${(state.time ?? TimeOfDay.now()).hour}:${(state.time ?? TimeOfDay.now()).minute}",
      note: event.note,
      phoneFrom: event.phoneFrom,
      phoneTo: event.phoneTo,
      usernameTo: event.usernameTo,
      usernameFrom: event.usernameFrom,
      notify: state.anonymous,
      floorTo: event.floorTo,
      floorFrom: event.floorFrom,
      houseFrom: event.houseFrom,
      houseTo: event.houseTo,
      comment: event.comment,
      value: event.value,
      instruction: event.instruction,
      paymentId:
          (event.paymentData.tag == "cash" || event.paymentData.tag == "wallet")
              ? event.paymentData.id
              : null,
    ));
    response.fold((l) async {
      emit(state.copyWith(isLoading: false));
      if (event.paymentData.tag == "maksekeskus") {
        emit(state.copyWith(isLoading: false));
        await AppRoute.goMaksekeskusBottomSheet(
            context: event.context,
            colors: event.colors,
            parcelId: l,
            parcel: true,
            onSuccess: (url) async {
              final res =
                  await AppRoute.goWebView(url: url, context: event.context);
              if (res) {
                AppRoute.goSuccessPage(event.context, onTap: () {
                  AppRoute.goParcelList(context: event.context);
                });
              } else {
                AppRoute.goFailPage(event.context);
              }
            });
      } else if (event.paymentData.tag != "cash" &&
          event.paymentData.tag != "wallet") {
        final res = await paymentsRepository.paymentWebView(
            parcel: true, name: event.paymentData.tag ?? "", parcelId: l);
        res.fold((l) async {
          final res = await AppRoute.goWebView(url: l, context: event.context);
          if (res) {
            AppRoute.goSuccessPage(event.context, onTap: () {
              AppRoute.goParcelList(context: event.context);
            });
          } else {
            AppRoute.goFailPage(event.context);
          }
        }, (r) {
          AppHelpers.errorSnackBar(context: event.context, message: r);
        });
      } else {
        AppRoute.goParcelList(context: event.context);
      }
    }, (r) {
      emit(state.copyWith(isLoading: false));
      AppHelpers.errorSnackBar(
        context: event.context,
        message: r,
      );
    });
  }

  selectType(event, emit) async {
    emit(state.copyWith(selectType: event.index));
    if (state.types.isNotEmpty &&
        state.addressFrom != null &&
        state.addressTo != null) {
      event.context
          .read<ParcelBloc>()
          .add(ParcelEvent.getCalculate(event.context));
    }
  }

  setToAddress(event, emit) async {
    emit(state.copyWith(addressTo: event.title, locationTo: event.location));
    if (state.types.isNotEmpty &&
        state.addressFrom != null &&
        state.addressTo != null) {
      event.context
          .read<ParcelBloc>()
          .add(ParcelEvent.getCalculate(event.context));
    }
  }

  setFromAddress(event, emit) async {
    emit(
        state.copyWith(addressFrom: event.title, locationFrom: event.location));
    if (state.types.isNotEmpty &&
        state.addressFrom != null &&
        state.addressTo != null) {
      event.context
          .read<ParcelBloc>()
          .add(ParcelEvent.getCalculate(event.context));
    }
  }

  switchAddress(event, emit) async {
    emit(state.copyWith(
        addressFrom: state.addressTo,
        locationFrom: state.locationTo,
        addressTo: state.addressFrom,
        locationTo: state.locationFrom));
    if (state.types.isNotEmpty &&
        state.addressFrom != null &&
        state.addressTo != null) {
      event.context
          .read<ParcelBloc>()
          .add(ParcelEvent.getCalculate(event.context));
    }
  }

  setTime(event, emit) async {
    emit(state.copyWith(time: event.time));
  }

  showParcel(event, emit) async {
    emit(state.copyWith(isLoading: event.parcel == null, parcel: event.parcel));
    final response = await parcelRepository.getSingleParcel(event.orderId);
    response.fold((l) async {
      emit(state.copyWith(parcel: l, isLoading: false));
    }, (r) {
      emit(state.copyWith(isLoading: false));
      AppHelpers.errorSnackBar(
        context: event.context,
        message: r,
      );
    });
  }
}
