import 'package:dartz/dartz.dart';
import 'package:goshops/infrastructure/model/request/create_order_model.dart';
import 'package:goshops/infrastructure/model/response/maksekeskus_response.dart';
import 'package:goshops/infrastructure/model/response/payments_response.dart';
import 'package:goshops/infrastructure/model/response/transactions_response.dart';

abstract class PaymentsInterface {
  Future<Either<PaymentsResponse, dynamic>> getPayments();

  Future<Either<TransactionsResponse, dynamic>> createTransaction({
    required int orderId,
    required int paymentId,
  });

  Future<Either<String, dynamic>> paymentWebView(
      {CreateOrderModel? order,
      required String name,
      bool parcel = false,
      int? parcelId});

  Future<Either<String, dynamic>> paymentWalletWebView(
      {required String name, required int walletId, required num price});

  Future<Either<bool, dynamic>> sendWallet(
      {required String uuid, required num price});

  Future<Either<MaksekeskusResponse, dynamic>> paymentMaksekeskusView({
    CreateOrderModel? order,
    bool parcel = false,
    bool wallet = false,
    int? parcelId,
    num? price,
  });
}
