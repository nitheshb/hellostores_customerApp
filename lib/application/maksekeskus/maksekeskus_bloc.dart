

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/model/request/create_order_model.dart';
import 'package:goshops/infrastructure/model/model/maksekeskus_data.dart';
import 'package:goshops/infrastructure/service/services.dart';

part 'maksekeskus_event.dart';

part 'maksekeskus_state.dart';

part 'maksekeskus_bloc.freezed.dart';

class MaksekeskusBloc extends Bloc<MaksekeskusEvent, MaksekeskusState> {
  MaksekeskusBloc() : super(const MaksekeskusState()) {
    on<SelectMethod>(selectMethod);
    on<FetchMaksekeskus>(fetchMaksekeskus);
  }

  selectMethod(event, emit) async {
    emit(state.copyWith(selectMethodLink: event.link));
  }

  fetchMaksekeskus(event, emit) async {
    emit(state.copyWith(isLoading: true));
    final res = await paymentsRepository.paymentMaksekeskusView(
      order: event.order,
      parcel: event.parcel ?? false,
      parcelId: event.parcelId,
      wallet: event.wallet ?? false,
      price: event.price,
    );
    res.fold((l) async {
      emit(state.copyWith(isLoading: false, maksekeskus: l.data));
    }, (r) {
      emit(state.copyWith(isLoading: false));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }
}
