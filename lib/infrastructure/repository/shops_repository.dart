import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/domain/interface/shop.dart';
import 'package:goshops/infrastructure/model/request/create_shop_request.dart';
import 'package:goshops/infrastructure/model/model/story_model.dart';
import 'package:goshops/infrastructure/model/response/shops_paginate_response.dart';
import 'package:goshops/infrastructure/model/response/single_shop_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';

class ShopsRepository implements ShopsInterface {
  @override
  Future<Either<ShopsPaginateResponse, dynamic>> getAllShops(
      {String? query, int? page}) async {
    final data = {
      'perPage': 16,
      'page': page,
      'column': 'r_avg',
      'sort': 'desc',
      'lang': LocalStorage.getLanguage()?.locale,
      if (LocalStorage.getAddress()?.countryId != null)
        'country_id': LocalStorage.getAddress()?.countryId,
      if (LocalStorage.getAddress()?.cityId != null)
        'city_id': LocalStorage.getAddress()?.cityId,
      if (query != null) "search": query
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/shops/paginate',
        queryParameters: data,
      );
      return left(ShopsPaginateResponse.fromJson(response.data));
    } catch (e, s) {
      debugPrint('==> get all shops failure: $e, $s');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<SingleShopResponse, dynamic>> getSingleShop(String uuid) async {
    final data = {'lang': LocalStorage.getLanguage()?.locale};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response =
          await client.get('/api/v1/rest/shops/$uuid', queryParameters: data);
      return left(SingleShopResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get single shop failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<bool, dynamic>> createShop(
      {required CreateShopModel shopRequest}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/dashboard/user/shops',
        data: shopRequest.toJson(),
      );
      return left(true);
    } catch (e) {
      debugPrint('==> edit shop failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<List<List<StoryModel?>?>, dynamic>> getStory(int page) async {
    final data = {
      'perPage': 30,
      'page': page,
      'lang': LocalStorage.getLanguage()?.locale,
      if (LocalStorage.getAddress()?.countryId != null)
        'country_id': LocalStorage.getAddress()?.countryId,
      if (LocalStorage.getAddress()?.cityId != null)
        'city_id': LocalStorage.getAddress()?.cityId,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/stories/paginate',
        queryParameters: data,
      );
      return left(storyModelFromJson(response.data) ?? []);
    } catch (e) {
      debugPrint('==> get all shops failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }
}
