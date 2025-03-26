

import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/model/model/brand_data.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'brand_event.dart';

part 'brand_state.dart';

part 'brand_bloc.freezed.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  int page = 0;

  BrandBloc() : super(const BrandState()) {
    on<FetchBrands>(fetchBrands);
  }

  fetchBrands(event, emit) async {
    if (event.isRefresh ?? false) {
      event.controller?.resetNoData();
      page = 0;
      emit(state.copyWith(brands: [], isLoading: true));
    }

    final res =
        await brandsRepository.getAllBrands(page: ++page, shopId: event.shopId);

    res.fold((l) {
      List<BrandData> list = List.from(state.brands);
      list.addAll(l.data ?? []);
      emit(state.copyWith(
        isLoading: false,
        brands: list,
      ));
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
}
