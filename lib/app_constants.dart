import 'dart:ui';
import 'package:flutter_remix/flutter_remix.dart';
import 'infrastructure/service/services.dart';
import 'presentation/style/style.dart';

abstract class AppConstants {
  AppConstants._();

  /// api urls
  static const String baseUrl = 'http://api.hellostores.in/v1';
  static const String drawingBaseUrl = 'https://api.openrouteservice.org/';
  static const String googleApiKey = 'Your map key';
  static const String privacyPolicyUrl = '$baseUrl/privacy-policy';
  static const String adminPageUrl = 'https://admin.goshops.org';
  static const String webUrl = 'https://goshops.org';
  static const String firebaseWebKey =
      'AIzaSyB2M2TwSukYPI9iRWHsBns79FIWdYTz6bU';
  static const String urlPrefix = 'https://goshops.page.link';
  static const String androidPackageName = 'org.goshops';
  static const String iosPackageName = 'org.goshops';
  static const String routingKey =
      '5b3ce3597851110001cf6248ed52930792d447839b83083b296b7909';
  static const String sellerAppAndroid =
      'https://play.google.com/store/apps/details?id=uzmart.seller';
  static const String sellerAppIos =
      'https://testflight.apple.com/join/ZjHulxhx';
  static const bool isDemo = false;
  static const bool isDevMode = false;
  static const bool autoTrn = true;
  static const bool isAcceptTerm = false;
  static const bool playGame = false;
  static const SignUpType signUpType = SignUpType.email;

  static const double radius = 8;
  static const double radiusMax = 12;

  /// social sign-in
  static const socialSignIn = [
    FlutterRemix.google_fill,
    FlutterRemix.facebook_fill,
    FlutterRemix.apple_fill,
  ];

  static const filterLayouts = [
    LayoutType.twoH,
    // LayoutType.three,
    LayoutType.twoV,
    LayoutType.one,
    // LayoutType.newUi,
  ];

  /// location
  static const double demoLatitude = 41.304223;
  static const double demoLongitude = 69.2348277;
  static const double pinLoadingMin = 0.116666667;
  static const double pinLoadingMax = 0.611111111;

  ///refresh duration
  static const Duration timeRefresh = Duration(seconds: 30);

  ///image
  static const String loginBg = "assets/images/loginBg.png";
  static const String darkBgChat = "assets/images/darkBg.jpeg";
  static const String lightBgChat = "assets/images/lightBg.jpeg";

  /// locales
  static const String localeCodeEn = 'en';

  /// notification
  static const String newOrder = 'new_order';
  static const String newParcelOrder = 'new_parcel_order';
  static const String newUserByReferral = 'new_user_by_referral';
  static const String statusChanged = 'status_changed';
  static const String newsPublish = 'news_publish';
  static const String addCashback = 'add_cashback';
  static const String shopApproved = 'shop_approved';
  static const String walletTopUp = 'wallet_top_up';

  static const List infoImage = [
    "assets/images/save.png",
    "assets/images/delivery.png",
    "assets/images/fast.png",
    "assets/images/set.png",
  ];


  static const List imageTypes = [
    '.png',
    '.jpg',
    '.jpeg',
    '.webp',
    '.svg',
    '.jfif',
    '.gif',
  ];

  static const Map socialIcon = {
    "facebook": FlutterRemix.facebook_fill,
    "instagram": FlutterRemix.instagram_fill,
    "telegram": FlutterRemix.telegram_fill,
    "youtube": FlutterRemix.youtube_fill,
    "linkedin": FlutterRemix.linkedin_fill,
    "snapchat": FlutterRemix.snapchat_fill,
    "wechat": FlutterRemix.wechat_fill,
    "whatsapp": FlutterRemix.whatsapp_fill,
    "twitch": FlutterRemix.twitch_fill,
    "discord": FlutterRemix.discord_fill,
    "pinterest": FlutterRemix.pinterest_fill,
    "steam": FlutterRemix.steam_fill,
    "spotify": FlutterRemix.spotify_fill,
    "reddit": FlutterRemix.reddit_fill,
    "skype": FlutterRemix.skype_fill,
    "twitter": FlutterRemix.twitter_fill,
  };

  static const List infoTitle = [
    TrKeys.saveTime,
    TrKeys.deliveryRestriction,
    TrKeys.fast,
    TrKeys.set,
  ];

  static const List<Color> adsColor = [
    CustomStyle.seeAllColor,
    CustomStyle.success,
    CustomStyle.rate,
    CustomStyle.primary,
  ];

  static const List<String> listOrderStatus = [
    TrKeys.canceled,
    TrKeys.delivered,
    TrKeys.pause,
    TrKeys.onAWay,
    TrKeys.ready,
    TrKeys.accepted,
    TrKeys.newKey,
  ];
}
