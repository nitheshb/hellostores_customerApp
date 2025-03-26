import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/model/request/product_filter_model.dart';
import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'product_event.dart';

part 'product_state.dart';

part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  int mostPage = 0;
  int popularPage = 0;
  int newPage = 0;
  int mostShopPage = 0;
  int newShopPage = 0;
  int common = 0;
  int discount = 0;
  int all = 0;

  ProductBloc() : super(const ProductState()) {
    on<FetchAllProduct>(fetchAllProduct);
    on<FetchMostSaleShopProduct>(fetchMostSaleShopProduct);
    on<FetchNewShopProduct>(fetchNewShopProduct);
    on<FetchMostSaleProduct>(fetchMostSaleProduct);
    on<FetchPopularProduct>(fetchPopularProduct);
    on<FetchLikeProduct>(fetchLikeProduct);
    on<FetchDiscountProduct>(fetchDiscountProduct);
    on<FetchNewProduct>(fetchNewProduct);
    on<FetchProducts>(fetchProducts);
    on<UpdateState>(updateState);
  }

  fetchAllProduct(event, emit) async {
    if (event.isRefresh ?? false) {
      event.controller?.resetNoData();
      all = 0;
      emit(state.copyWith(allProductList: [], isLoadingMostSale: true));
    }
    final res = await productsRepository.getAllProducts(
        filter: ProductFilterModel(page: ++all));
    res.fold((l) {
      List<ProductData> list = List.from(state.allProductList);
      list.addAll(l.data ?? []);
      emit(state.copyWith(
        isLoadingMostSale: false,
        allProductList: list,
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
      emit(state.copyWith(isLoadingMostSale: false));
      if (event.isRefresh ?? false) {
        event.controller?.refreshFailed();
      }
      event.controller?.loadFailed();

      AppHelpers.errorSnackBar(
        context: event.context,
        message: r,
        
      );
    });
  }

  fetchMostSaleShopProduct(event, emit) async {
    if (event.isRefresh ?? false) {
      event.controller?.resetNoData();
      mostShopPage = 0;
      emit(state.copyWith(mostSaleShopProduct: [], isLoadingMostSale: true));
    }
    final res = await productsRepository.fetchProducts(
      filter: ProductFilterModel(
        page: ++mostShopPage,
        shopId: event.shopId,
        isMostSold: true,
      ),
    );
    res.fold((l) {
      List<ProductData> list = List.from(state.mostSaleShopProduct);
      list.addAll(l.data ?? []);
      emit(state.copyWith(
        isLoadingMostSale: false,
        mostSaleShopProduct: list,
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
      emit(state.copyWith(isLoadingMostSale: false));
      if (event.isRefresh ?? false) {
        event.controller?.refreshFailed();
      }
      event.controller?.loadFailed();
      AppHelpers.errorSnackBar(
        context: event.context,
        message: r,
        
      );
    });
  }

  fetchNewShopProduct(event, emit) async {
    if (event.isRefresh ?? false) {
      event.controller?.resetNoData();
      newShopPage = 0;
      emit(state.copyWith(newShopProduct: [], isLoadingNew: true));
    }
    final res = await productsRepository.fetchProducts(
        filter: ProductFilterModel(
      page: ++newShopPage,
      isNew: true,
      shopId: event.shopId,
    ));
    res.fold((l) {
      List<ProductData> list = List.from(state.newShopProduct);
      list.addAll(l.data ?? []);
      emit(state.copyWith(
        isLoadingNew: false,
        newShopProduct: list,
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
      emit(state.copyWith(isLoadingNew: false));
      if (event.isRefresh ?? false) {
        event.controller?.refreshFailed();
      }
      event.controller?.loadFailed();
      AppHelpers.errorSnackBar(
        context: event.context,
        message: r,
        
      );
    });
  }

  fetchMostSaleProduct(event, emit) async {
    if (event.isRefresh ?? false) {
      event.controller?.resetNoData();
      mostPage = 0;
      emit(state.copyWith(mostSaleProduct: [], isLoadingMostSale: true));
    }
    final res = await productsRepository.fetchProducts(
        filter: ProductFilterModel(
      page: ++mostPage,
      isMostSold: true,
    ));
    res.fold((l) {
      List<ProductData> list = List.from(state.mostSaleProduct);
      list.addAll(l.data ?? []);
      emit(state.copyWith(
          isLoadingMostSale: false,
          mostSaleProduct: list,
          mostSaleProductCount: l.meta?.total ?? 0));
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
      emit(state.copyWith(isLoadingMostSale: false));
      if (event.isRefresh ?? false) {
        event.controller?.refreshFailed();
      }
      event.controller?.loadFailed();
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  fetchPopularProduct(event, emit) async {
    if (event.isRefresh ?? false) {
      event.controller?.resetNoData();
      popularPage = 0;
      emit(state.copyWith(popularProduct: [], isLoadingPopular: true));
    }
    final res = await productsRepository.fetchProducts(
      filter: ProductFilterModel(page: ++popularPage, isPopular: true),
    );
    res.fold((l) {
      List<ProductData> list = List.from(state.popularProduct);
      list.addAll(l.data ?? []);
      emit(state.copyWith(
        isLoadingPopular: false,
        popularProduct: list,
        popularProductCount: l.meta?.total ?? 0,
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
      emit(state.copyWith(isLoadingPopular: false));
      if (event.isRefresh ?? false) {
        event.controller?.refreshFailed();
      }
      event.controller?.loadFailed();
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  fetchLikeProduct(event, emit) async {
    if (!(event.isRefresh ?? false)) {
      event.controller?.resetNoData();
      emit(state.copyWith(likeProducts: [], isLoadingLike: true));
    }
    if (LocalStorage.getLikedProductsList().isEmpty &&
        LocalStorage.getToken().isEmpty) {
      emit(state.copyWith(isLoadingLike: false));
      return;
    }
    final res = await productsRepository
        .getProductsByIds(LocalStorage.getLikedProductsList());
    res.fold((l) {
      emit(state.copyWith(
        isLoadingLike: false,
        likeProducts: l.data ?? [],
      ));
      event.controller?.refreshCompleted();
    }, (r) {
      emit(state.copyWith(isLoadingLike: false));
      if (event.isRefresh ?? false) {
        event.controller?.refreshFailed();
      }
      event.controller?.loadFailed();
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  fetchDiscountProduct(event, emit) async {
    if (event.isRefresh ?? false) {
      event.controller?.resetNoData();
      discount = 0;
      emit(state.copyWith(discountProduct: [], isLoadingDiscount: true));
    }
    final res = await productsRepository.getDiscountProducts(page: ++discount);
    res.fold((l) {
      List<ProductData> list = List.from(state.discountProduct);
      list.addAll(l.data ?? []);
      emit(state.copyWith(
        isLoadingDiscount: false,
        discountProduct: list,
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
      emit(state.copyWith(isLoadingDiscount: false));
      if (event.isRefresh ?? false) {
        event.controller?.refreshFailed();
      }
      event.controller?.loadFailed();
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  fetchNewProduct(event, emit) async {
    if (event.isRefresh ?? false) {
      event.controller?.resetNoData();
      newPage = 0;
      emit(state.copyWith(newProduct: [], isLoadingNew: true));
    }
    final res = await productsRepository.fetchProducts(
        filter: ProductFilterModel(page: ++newPage, isNew: true));
    res.fold((l) {
      List<ProductData> list = List.from(state.newProduct);
      list.addAll(l.data ?? []);
      emit(
        state.copyWith(
          isLoadingNew: false,
          newProduct: list,
          newProductCount: l.meta?.total ?? 0,
        ),
      );
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
      emit(state.copyWith(isLoadingNew: false));
      if (event.isRefresh ?? false) {
        event.controller?.refreshFailed();
      }
      event.controller?.loadFailed();
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  fetchProducts(event, emit) async {
    if (event.isRefresh ?? false) {
      event.controller?.resetNoData();
      common = 0;
      emit(state.copyWith(commonProduct: [], isLoading: true));
    }
    final res = await productsRepository.fetchProducts(
        filter: ProductFilterModel(
      page: ++common,
      categoryId: event.categoryId,
      shopId: event.shopId,
      isMostSold: event.isMostSale,
      isNew: event.isNew,
      isPopular: event.isPopular,
      priceMin: event.minPrice,
      priceMax: event.maxPrice,
      brandIds: event.brandId,
      categoryIds: event.categoryIds,
      extrasId: event.extrasId,
      priceFrom: event.priceFrom,
      priceTo: event.priceTo,
      bannerId: event.bannerId,
      query: event.query,
    ));

    res.fold((l) {
      List<ProductData> list = List.from(state.commonProduct);
      list.addAll(l.data ?? []);
      emit(state.copyWith(
          isLoading: false,
          commonProduct: list,
          totalCount: l.meta?.total ?? 0));
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

  updateState(event, emit) {
    emit(state.copyWith(isLoadingNew: !state.isLoadingNew));
    emit(state.copyWith(isLoadingNew: !state.isLoadingNew));
  }
}
