// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/domain/interface/review.dart';
import 'package:goshops/infrastructure/model/model/reivew_statistic_model.dart';
import 'package:goshops/infrastructure/model/model/review_request_model.dart';
import 'package:goshops/infrastructure/model/response/review_check_response.dart';
import 'package:goshops/infrastructure/model/response/review_pagination_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';

class ReviewRepository implements ReviewInterface {
  @override
  Future<Either<ReviewCountModel, dynamic>> fetchReview({
    int? shopId,
    int? productId,
    int? driverId,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response;
      if (shopId != null) {
        response =
            await client.get('/api/v1/rest/shops/$shopId/reviews-group-rating');
      } else if (driverId != null) {
        response = await client
            .get('/api/v1/rest/users/$driverId/reviews-group-rating');
      } else {
        response = await client
            .get('/api/v1/rest/products/$productId/reviews-group-rating');
      }
      return left(ReviewCountModel.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get review failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<ReviewResponseModel, dynamic>> fetchReviewList({required ReviewRequestModel requestModel}) async {
    final data = {"column": "user"};
    try {
      final client =
          dioHttp.client(requireAuth: LocalStorage.getToken().isNotEmpty);
      final response;
      if (requestModel.shopId != null) {
        response = await client.get('/api/v1/rest/shops/${requestModel.shopId}/reviews',
            queryParameters: data);
      } else if (requestModel.productUuid != null) {
        response = await client.get('/api/v1/rest/products/reviews/${requestModel.productUuid}',
            queryParameters: data);
      } else if (requestModel.driverId != null) {
        response = await client.get(
            '/api/v1/rest/users/reviews?assign=deliveryman1&assign_id=${requestModel.driverId}',
            queryParameters: data);
      } else {
        response = await client.get('/api/v1/rest/blogs/${requestModel.blogId}/reviews',
            queryParameters: data);
      }
      return left(ReviewResponseModel.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get review shop failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<bool, dynamic>> sendReviewProduct(
      {required String? productUuid,
      required String? title,
      required List list,
      required num? rate}) async {
    try {
      final data = {
        'rating': rate,
        if (title != "") 'comment': title,
        "images": [for (int i = 0; i < list.length; i++) list[i]]
      };
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/v1/dashboard/user/products/review/$productUuid',
          data: data);
      return left(true);
    } catch (e) {
      debugPrint('==> send review product failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<bool, dynamic>> sendReviewShop(
      {required int? shopId,
      required String? title,
      required List list,
      required num? rate}) async {
    try {
      final data = {
        'rating': rate,
        if (title != "") 'comment': title,
        "images": [for (int i = 0; i < list.length; i++) list[i]]
      };
      final client = dioHttp.client(requireAuth: true);

      await client.post('/api/v1/dashboard/user/shops/review/$shopId',
          data: data);
      return left(true);
    } catch (e) {
      debugPrint('==> send review shop failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<bool, dynamic>> sendReviewOrder(
      {required int? orderId,
      required String? title,
      required List list,
      required num? rate}) async {
    try {
      final data = {
        'rating': rate,
        if (title != "") 'comment': title,
        "images": [for (int i = 0; i < list.length; i++) list[i]]
      };
      final client = dioHttp.client(requireAuth: true);

      await client.post('/api/v1/dashboard/user/orders/deliveryman-review/$orderId',
          data: data);
      return left(true);
    } catch (e) {
      debugPrint('==> send review shop failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<bool, dynamic>> sendReviewBlog(
      {required int? blogId,
      required String? title,
      required List list,
      required num? rate}) async {
    try {
      final data = {
        'rating': rate,
        if (title != "") 'comment': title,
        "images": [for (int i = 0; i < list.length; i++) list[i]]
      };
      final client = dioHttp.client(requireAuth: true);

      await client.post('/api/v1/dashboard/user/blogs/review/$blogId',
          data: data);
      return left(true);
    } catch (e) {
      debugPrint('==> send review blog failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<ReviewCheckResponse, dynamic>> checkReview(
      {int? shopId, int? productId, int? blogId}) async {
    try {
      final data = {
        'type': shopId != null
            ? "shop"
            : productId != null
                ? ""
            ""
            ""
                : "blog",
        "type_id": shopId ?? productId ?? blogId
      };
      final client =
          dioHttp.client(requireAuth: LocalStorage.getToken().isNotEmpty);

      final res =
          await client.get('/api/v1/rest/added-review', queryParameters: data);
      return left(ReviewCheckResponse.fromJson(res.data));
    } catch (e) {
      debugPrint('==> check review failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }
}
