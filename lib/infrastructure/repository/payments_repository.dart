// ignore_for_file: deprecated_member_use

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/domain/interface/payments.dart';
import 'package:goshops/infrastructure/model/request/create_order_model.dart';
import 'package:goshops/infrastructure/model/response/maksekeskus_response.dart';
import 'package:goshops/infrastructure/model/response/payments_response.dart';
import 'package:goshops/infrastructure/model/response/transactions_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';

class PaymentsRepository implements PaymentsInterface {
  @override
  Future<Either<PaymentsResponse, dynamic>> getPayments() async {
    final data = {'lang': LocalStorage.getLanguage()?.locale};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response =
          await client.get('/api/v1/rest/payments', queryParameters: data);
      return left(PaymentsResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get payments failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<TransactionsResponse, dynamic>> createTransaction({
    required int orderId,
    required int paymentId,
  }) async {
    final data = {'payment_sys_id': paymentId};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/payments/order/$orderId/transactions',
        data: data,
      );
      return left(
        TransactionsResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> create transaction failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<String, dynamic>> paymentWebView(
      {CreateOrderModel? order,
        required String name,
        bool parcel = false,
        int? parcelId}) async {
    try {
      final data = {"parcel_id": parcelId};
      final client = dioHttp.client(requireAuth: true);
      final res = await client.post('/api/v1/dashboard/user/$name-process',
          data: parcel ? data : order?.toJson(isPayment: false));

      return left(res.data["data"]["data"]["url"] ?? "");
    } catch (e) {
      debugPrint('==> web view failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<String, dynamic>> paymentWalletWebView(
      {required String name, required int walletId, required num price}) async {
    try {
      final data = {
        'wallet_id': walletId,
        'total_price': price,
        "currency_id": LocalStorage.getSelectedCurrency()?.id
      };

      final client = dioHttp.client(requireAuth: true);
      final res =
          await client.post('/api/v1/dashboard/user/$name-process', data: data);

      return left(res.data["data"]["data"]["url"] ?? "");
    } catch (e) {
      debugPrint('==> web view wallet failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<bool, dynamic>> sendWallet(
      {required String uuid, required num price}) async {
    try {
      final data = {
        'uuid': uuid,
        'price': price,
        "currency_id": LocalStorage.getSelectedCurrency()?.id
      };

      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/v1/dashboard/user/wallet/send', data: data);

      return left(true);
    } catch (e) {
      debugPrint('==> send wallet failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<Either<MaksekeskusResponse, dynamic>> paymentMaksekeskusView({
    CreateOrderModel? order,
    bool parcel = false,
    bool wallet = false,
    int? parcelId,
    num? price,
  }) async {
    try {
      final data = parcel
          ? {"parcel_id": parcelId}
          : wallet
          ? {
        'wallet_id': LocalStorage.getUser().wallet?.id,
        'total_price': price ?? 0,
        "currency_id": LocalStorage.getSelectedCurrency()?.id
      }
          : order?.toJson(isPayment: false);
      debugPrint('==> payment maksekeskus request: $data');
      final client = dioHttp.client(requireAuth: true);
      final res = await client
          .post('/api/v1/dashboard/user/maksekeskus-process', data: data);

      return left(MaksekeskusResponse.fromJson(res.data["data"]));
    } catch (e) {
      debugPrint('==> payment maksekeskus  failure: $e');
      return right(AppHelpers.errorHandler(e));
    }
  }
}
