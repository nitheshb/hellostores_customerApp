import 'package:dartz/dartz.dart';
import 'package:goshops/infrastructure/model/model/reivew_statistic_model.dart';
import 'package:goshops/infrastructure/model/model/review_request_model.dart';
import 'package:goshops/infrastructure/model/response/review_check_response.dart';
import 'package:goshops/infrastructure/model/response/review_pagination_response.dart';

abstract class ReviewInterface {
  Future<Either<ReviewResponseModel, dynamic>> fetchReviewList(
      {required ReviewRequestModel requestModel});

  Future<Either<ReviewCountModel, dynamic>> fetchReview({
    int? shopId,
    int? driverId,
    int? productId,
  });

  Future<Either<bool, dynamic>> sendReviewProduct({
    required String? productUuid,
    required String? title,
    required num? rate,
    required List list,
  });

  Future<Either<bool, dynamic>> sendReviewShop({
    required int? shopId,
    required String? title,
    required num? rate,
    required List list,
  });

  Future<Either<bool, dynamic>> sendReviewOrder({
    required int? orderId,
    required String? title,
    required num? rate,
    required List list,
  });

  Future<Either<bool, dynamic>> sendReviewBlog({
    required int? blogId,
    required String? title,
    required num? rate,
    required List list,
  });

  Future<Either<ReviewCheckResponse, dynamic>> checkReview({
    int? shopId,
    int? productId,
    int? blogId,
  });
}
