import 'package:dartz/dartz.dart';
import 'package:goshops/infrastructure/model/response/categories_paginate_response.dart';

abstract class CategoryInterface {
  Future<Either<CategoriesPaginateResponse,dynamic>> getAllCategories({required int page,String? query});

  Future<Either<CategoriesPaginateResponse,dynamic>> getAllCategoriesByShop({required int page,required int shopId});
}