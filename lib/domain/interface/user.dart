import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:goshops/infrastructure/model/model/notification_data.dart';
import 'package:goshops/infrastructure/model/model/referral_model.dart';
import 'package:goshops/infrastructure/model/request/update_profile_model.dart';
import 'package:goshops/infrastructure/model/model/user_model.dart';
import 'package:goshops/infrastructure/model/response/count_of_notifications_data.dart';
import 'package:goshops/infrastructure/model/response/digital_list_response.dart';
import 'package:goshops/infrastructure/model/response/notification_response.dart';
import 'package:goshops/infrastructure/model/response/profile_response.dart';
import 'package:goshops/infrastructure/model/response/transaction_histories_response.dart';

abstract class UserInterface {
  Future<Either<ProfileResponse, dynamic>> getProfileDetails(
      BuildContext context);

  Future deleteAccount();

  Future setLikeProduct({required int id});

  Future setLikeProductList({required List<int> ids});

  Future removeLikeProduct({required int id});

  Future<Either<ProfileResponse, dynamic>> updateProfile(
      {required UpdateProfileModel updateProfile});

  Future<Either<ProfileResponse, dynamic>> updatePassword({
    required String password,
    required String passwordConfirmation,
  });

  Future updateFirebaseToken(String? token);

  Future<Either<NotificationResponse, dynamic>> getNotifications({
    int? page,
  });

  Future<Either<DigitalListResponse, dynamic>> getDigitalList({
    int? page,
  });

  Future<Either<String, dynamic>> getDigitalProduct({
    required int id,
  });

  Future<Either<bool, dynamic>> readOne({
    int? id,
  });

  Future<Either<bool, dynamic>> deleteNotification({
    int? id,
  });

  Future<Either<bool, dynamic>> updateNotification(
      {List<NotificationsModel>? notifications});

  Future<Either<NotificationResponse, dynamic>> readAll();

  Future<Either<CountNotificationModel, dynamic>> getCount(
      BuildContext context);

  Future<Either<TransactionPaginationResponse, dynamic>> getTransactions(
      int page);

  Future<Either<List<UserModel>, dynamic>> searchUser(
      {required String name, required int page});

  Future<Either<ReferralModel, dynamic>> getReferralDetails();
}
