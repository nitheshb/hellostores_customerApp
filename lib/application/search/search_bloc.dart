

import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/model/model/brand_data.dart';
import 'package:goshops/infrastructure/model/request/product_filter_model.dart';
import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/infrastructure/model/model/shop_model.dart';
import 'package:goshops/infrastructure/model/response/categories_paginate_response.dart';
import 'package:goshops/infrastructure/service/services.dart';

part 'search_event.dart';

part 'search_state.dart';

part 'search_bloc.freezed.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  int? shopId;

  SearchBloc() : super(const SearchState()) {

    on<SearchShops>(searchShops);

    on<SetQuery>(setQuery);

    on<SearchProduct>(searchProduct);

    on<SearchCategory>(searchCategory);

    on<SearchBrand>(searchBrand);

    on<UpdateRecently>(updateRecently);
  }

  searchShops(event, emit) async {
    emit(state.copyWith(isShopLoading: true));

    final res = await shopsRepository.getAllShops(query: state.query, page: 1);
    res.fold((l) {
      emit(state.copyWith(isShopLoading: false, shops: l.data ?? []));
    }, (r) {
      emit(state.copyWith(isShopLoading: false));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  setQuery(event, emit) async {
    shopId = event.shopId;
    emit(state.copyWith(query: event.query));
  }

  searchProduct(event, emit) async {
    emit(state.copyWith(isProductLoading: true));

    final res = await productsRepository.fetchProducts(
        filter: ProductFilterModel(query: state.query, page: 1, shopId: shopId));
    res.fold((l) {
      emit(state.copyWith(isProductLoading: false, products: l.data ?? []));
    }, (r) {
      emit(state.copyWith(isProductLoading: false));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  searchCategory(event, emit) async {
    emit(state.copyWith(isCategoryLoading: true));

    final res =
    await categoriesRepository.getAllCategories(query: state.query, page: 1);
    res.fold((l) {
      emit(
          state.copyWith(isCategoryLoading: false, categories: l.data ?? []));
    }, (r) {
      emit(state.copyWith(isCategoryLoading: false));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  searchBrand(event, emit) async {
    emit(state.copyWith(isBrandLoading: true));

    final res = await brandsRepository.getAllBrands(query: state.query, page: 1);
    res.fold((l) {
      emit(state.copyWith(isBrandLoading: false, brands: l.data ?? []));
    }, (r) {
      emit(state.copyWith(isBrandLoading: false));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  updateRecently(event, emit) async {
    emit(state.copyWith(isShopLoading: true));
    emit(state.copyWith(isShopLoading: false));
  }
}
