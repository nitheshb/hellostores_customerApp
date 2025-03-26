

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/model/response/categories_paginate_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'category_event.dart';

part 'category_state.dart';

part 'category_bloc.freezed.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  int page = 0;

  CategoryBloc() : super(const CategoryState()) {
    on<FetchCategory>(fetchCategory);

    on<SelectCategory>(selectCategory);
    on<SelectOnlyCategory>(selectOnlyCategory);

    on<SelectCategoryTwo>(selectCategoryTwo);
  }

  fetchCategory(event, emit) async {
    if (event.isRefresh ?? false) {
      event.controller?.resetNoData();
      page = 0;
      emit(state.copyWith(categories: [], isLoadingCategory: true));
    }
    final Either<CategoriesPaginateResponse, dynamic> res;
    if (event.shopId != null) {
      res = await categoriesRepository.getAllCategoriesByShop(
          page: ++page, shopId: event.shopId ?? 0);
    } else {
      res = await categoriesRepository.getAllCategories(page: ++page);
    }

    res.fold((l) {
      List<CategoryData> list = List.from(state.categories);
      list.addAll(l.data ?? []);
      emit(state.copyWith(
          isLoadingCategory: false,
          categories: list,
          selectCategoryTwo: list.isNotEmpty ? list.first : null));
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
      emit(state.copyWith(isLoadingCategory: false));
      if (event.isRefresh ?? false) {
        event.controller?.refreshFailed();
      }
      event.controller?.loadFailed();

      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  selectCategory(event, emit) async {
    if (event.category?.id == state.selectCategory?.id) {
      emit(state.copyWith(selectCategory: null));
    } else {
      emit(state.copyWith(selectCategory: event.category));
    }
  }

  selectOnlyCategory(event, emit) async {
    emit(state.copyWith(selectCategory: event.category));
  }

  selectCategoryTwo(event, emit) async {
    if (event.category?.id == state.selectCategoryTwo?.id) {
      emit(state.copyWith(selectCategoryTwo: null));
    } else {
      emit(state.copyWith(selectCategoryTwo: event.category));
    }
  }
}
