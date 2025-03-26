

import 'package:dartz/dartz.dart';
import 'package:goshops/infrastructure/model/request/create_parcel_model.dart';
import 'package:goshops/infrastructure/model/model/location_model.dart';
import 'package:goshops/infrastructure/model/model/parcel_order_model.dart';
import 'package:goshops/infrastructure/model/response/parcel_calculate_response.dart';
import 'package:goshops/infrastructure/model/response/parcel_paginate_response.dart';
import 'package:goshops/infrastructure/model/response/parcel_response.dart';

abstract class ParcelInterface {
  Future<Either<ParcelTypeResponse,dynamic>> getTypes();

  Future<Either<ParcelCalculateResponse,dynamic>> getCalculate(
      {required int typeId,
      required LocationModel from,
      required LocationModel to});

  Future<Either> orderParcel(
      {required CreateParcelModel parcel});


  Future<Either<ParcelPaginateResponse,dynamic>> getActiveParcel(int page);

  Future<Either<ParcelPaginateResponse,dynamic>> getHistoryParcel(int page);

  Future<Either<ParcelOrder,dynamic>> getSingleParcel(num orderId);


  Future<Either<dynamic,dynamic>> addReview(
      num orderId, {
        required double rating,
        required String comment,
      });
}
