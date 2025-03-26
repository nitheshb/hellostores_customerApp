import 'package:dartz/dartz.dart';
import 'package:goshops/infrastructure/model/request/filter_model.dart';
import 'package:goshops/infrastructure/model/request/product_filter_model.dart';
import 'package:goshops/infrastructure/model/response/compare_response.dart';
import 'package:goshops/infrastructure/model/response/filter_response.dart';
import 'package:goshops/infrastructure/model/response/products_paginate_response.dart';
import 'package:goshops/infrastructure/model/response/single_product_response.dart';

abstract class ProductsInterface {
  Future<Either<ProductsPaginateResponse, dynamic>> fetchProducts(
      {required ProductFilterModel filter});

  Future<Either<SingleProductResponse, dynamic>> getProductDetails(String uuid);



  Future<Either<ProductsPaginateResponse, dynamic>> getRelatedProducts(
      {String? productUuid, required int page});

  Future<Either<ProductsPaginateResponse, dynamic>> getBuyWithProducts(
      {int? productId, required int page});

  Future<Either<ProductsPaginateResponse, dynamic>> getAllProducts(
      {required ProductFilterModel filter});

  Future<Either<ProductsPaginateResponse, dynamic>> getProductsByIds(
    List<int> ids,
  );

  Future<Either<ProductsPaginateResponse, dynamic>> getProductsViewed(
      {required int page, required int productId});

  Future<Either<CompareResponse, dynamic>> getCompare({required int page});

  Future addReview(
    String productUuid,
    String comment,
    double rating,
    String? imageUrl,
  );

  Future<Either<ProductsPaginateResponse, dynamic>> getDiscountProducts({
    int? page,
  });

  Future<Either<FilterResponse, dynamic>> fetchFilter(
      {required FilterModel filter});
}
