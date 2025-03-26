import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/domain/interface/parcel.dart';
import 'package:goshops/infrastructure/model/request/create_parcel_model.dart';
import 'package:goshops/infrastructure/model/model/location_model.dart';
import 'package:goshops/infrastructure/model/model/parcel_order_model.dart';
import 'package:goshops/infrastructure/model/response/parcel_calculate_response.dart';
import 'package:goshops/infrastructure/model/response/parcel_paginate_response.dart';
import 'package:goshops/infrastructure/model/response/parcel_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';

class ParcelRepository implements ParcelInterface {
  @override
  Future<Either<dynamic, dynamic>> addReview(
    num orderId, {
    required double rating,
    required String comment,
  }) async {
    final data = {'rating': rating, if (comment != "") 'comment': comment};
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/dashboard/user/parcel-orders/deliveryman-review/$orderId',
        data: data,
      );
      return left(true);
    } catch (e) {
      debugPrint('==> add parcel review failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<ParcelTypeResponse, dynamic>> getTypes() async {
    final data = {'lang': LocalStorage.getLanguage()?.locale};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/v1/rest/parcel-order/types',
          queryParameters: data);
      return left(
        ParcelTypeResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get parcel type failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<ParcelCalculateResponse, dynamic>> getCalculate(
      {required int typeId,
      required LocationModel from,
      required LocationModel to}) async {
    final data = {
      'lang': LocalStorage.getLanguage()?.locale,
      'type_id': typeId,
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'address_from[latitude]': from.latitude,
      'address_from[longitude]': from.longitude,
      'address_to[latitude]': to.latitude,
      'address_to[longitude]': to.longitude,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
          '/api/v1/rest/parcel-order/calculate-price',
          queryParameters: data);
      return left(
        ParcelCalculateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get parcel type failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either> orderParcel({required CreateParcelModel parcel}) async {
    try {
      final client = dioHttp.client(requireAuth: true);

      final res = await client.post('/api/v1/dashboard/user/parcel-orders',
          data: parcel.toJson());
      return left(res.data["data"]["id"]);
    } catch (e) {
      debugPrint('==> get parcel order failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<ParcelPaginateResponse, dynamic>> getActiveParcel(
      int page) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
      'page': page,
      'statuses[0]': "new",
      "statuses[1]": "accepted",
      "statuses[2]": "ready",
      "statuses[3]": "on_a_way",
      "order_statuses": true,
      "perPage": 10
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/user/parcel-orders',
        queryParameters: data,
      );
      return left(
        ParcelPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get open parcel failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<ParcelPaginateResponse, dynamic>> getHistoryParcel(
      int page) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
      'statuses[0]': "delivered",
      "statuses[1]": "canceled",
      "order_statuses": true,
      "perPage": 10,
      "page": page
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/user/parcel-orders',
        queryParameters: data,
      );
      return left(
        ParcelPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get canceled parcel failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<ParcelOrder, dynamic>> getSingleParcel(num orderId) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/user/parcel-orders/$orderId',
        queryParameters: data,
      );
      return left(
        ParcelOrder.fromJson(response.data["data"]),
      );
    } catch (e) {
      debugPrint('==> get single parcel failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }
}
