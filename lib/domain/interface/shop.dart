import 'package:dartz/dartz.dart';
import 'package:goshops/infrastructure/model/request/create_shop_request.dart';
import 'package:goshops/infrastructure/model/model/story_model.dart';
import 'package:goshops/infrastructure/model/response/shops_paginate_response.dart';
import 'package:goshops/infrastructure/model/response/single_shop_response.dart';

abstract class ShopsInterface {
  Future<Either<ShopsPaginateResponse, dynamic>> getAllShops(
      {String? query, int? page});

  Future<Either<SingleShopResponse, dynamic>> getSingleShop(String uuid);

  Future<Either<bool, dynamic>> createShop(
      {required CreateShopModel shopRequest});

  Future<Either<List<List<StoryModel?>?>, dynamic>> getStory(int page);
}
