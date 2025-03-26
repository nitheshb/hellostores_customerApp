import 'package:colornames/colornames.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ftoast/ftoast.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/cart/cart_bloc.dart';
import 'package:goshops/application/products/product_bloc.dart';
import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/infrastructure/model/model/review_data.dart';
import 'package:goshops/infrastructure/model/response/delivery_point_response.dart';
import 'package:goshops/infrastructure/model/response/global_settings_response.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'package:goshops/presentation/style/theme/theme_wrapper.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

abstract class AppHelpers {
  AppHelpers._();

  static String errorHandler(e, {String? statusCode}) {
    return (e.runtimeType == DioException)
        ? ((e as DioException).response?.data["message"] == "Bad request."
            ? e.response?.data["params"] != null
                ? (e.response?.data["params"] as Map).values.first[0]
                : e.response?.data["message"]
            : e.response?.data["message"])
        : e.toString();
  }

  static String numberFormat(num? number,
      {String? symbol, bool? isOrder, int? decimalDigits}) {
    if (LocalStorage.getSelectedCurrency()?.position == "before") {
      return NumberFormat.currency(
        customPattern: '\u00a4#,###.#',
        symbol: (isOrder ?? false)
            ? symbol
            : LocalStorage.getSelectedCurrency()?.symbol,
        decimalDigits: decimalDigits ?? 2,
      ).format(number ?? 0);
    } else {
      return NumberFormat.currency(
        customPattern: '#,###.#\u00a4',
        symbol: (isOrder ?? false)
            ? symbol
            : LocalStorage.getSelectedCurrency()?.symbol,
        decimalDigits: decimalDigits ?? 2,
      ).format(number ?? 0);
    }
  }

  static NumberFormat format() {
    if (LocalStorage.getSelectedCurrency()?.position == "before") {
      return NumberFormat.currency(
        customPattern: '#,###.#',
        symbol: LocalStorage.getSelectedCurrency()?.symbol,
        decimalDigits: 0,
      );
    } else {
      return NumberFormat.currency(
        customPattern: '#,###.##',
        symbol: LocalStorage.getSelectedCurrency()?.symbol,
        decimalDigits: 0,
      );
    }
  }

  static openDialog({
    required BuildContext context,
    required String title,
  }) {
    return showDialog(
      context: context,
      builder: (_) {
        return ThemeWrapper(
          builder: (colors, controller) {
            return Dialog(
              backgroundColor: colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                margin: EdgeInsets.all(24.w),
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: colors.backgroundColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMax.r),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: CustomStyle.interNormal(
                            color: colors.textBlack, size: 18),
                      ),
                      24.verticalSpace,
                      CustomButton(
                        onTap: () => Navigator.pop(context),
                        title: getTranslation(TrKeys.close),
                        bgColor: CustomStyle.primary,
                        titleColor: CustomStyle.white,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static showCustomDialog({
    required BuildContext context,
    required Widget content,
  }) {
    return showDialog(
      context: context,
      builder: (_) {
        return ThemeWrapper(
          builder: (colors, controller) {
            return Dialog(
              backgroundColor: colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
              child: content,
            );
          },
        );
      },
    );
  }

  static openDialogImagePicker({
    required BuildContext context,
    required VoidCallback openCamera,
    required VoidCallback openGallery,
  }) {
    return showDialog(
      context: context,
      builder: (_) {
        return ThemeWrapper(
          builder: (colors, controller) {
            return Dialog(
              backgroundColor: colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                margin: EdgeInsets.all(24.w),
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: colors.backgroundColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMax.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      getTranslation(TrKeys.selectPhoto),
                      textAlign: TextAlign.center,
                      style: CustomStyle.interNormal(
                          color: colors.textBlack, size: 18),
                    ),
                    const Divider(),
                    8.verticalSpace,
                    ButtonEffectAnimation(
                      onTap: openCamera,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.r, vertical: 8.r),
                        child: Row(
                          children: [
                            Icon(
                              FlutterRemix.camera_lens_line,
                              color: colors.textBlack,
                            ),
                            4.horizontalSpace,
                            Text(
                              getTranslation(TrKeys.takePhoto),
                              textAlign: TextAlign.center,
                              style: CustomStyle.interNormal(
                                  color: colors.textBlack, size: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    8.verticalSpace,
                    ButtonEffectAnimation(
                      onTap: openGallery,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.r, vertical: 8.r),
                        child: Row(
                          children: [
                            Icon(
                              FlutterRemix.gallery_line,
                              color: colors.textBlack,
                            ),
                            4.horizontalSpace,
                            Text(
                              getTranslation(TrKeys.chooseFromLibrary),
                              textAlign: TextAlign.center,
                              style: CustomStyle.interNormal(
                                  color: colors.textBlack, size: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static errorSnackBar({
    required BuildContext context,
    required String message,
  }) {
    FToast.toast(context,
        toast: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              76.verticalSpace,
              Container(
                  padding: EdgeInsets.all(16.r),
                  margin: REdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                      color: CustomStyle.primary,
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Text(
                    message,
                    style: CustomStyle.interNormal(
                        color: CustomStyle.white, size: 14),
                    maxLines: 24,
                  ))
            ],
          ),
        ));
  }

  static void showCustomModalBottomSheet({
    required BuildContext context,
    required Widget modal,
    double radius = AppConstants.radiusMax,
    bool isDrag = true,
    bool isDismissible = true,
    double paddingTop = 200,
  }) {
    showModalBottomSheet(
      isDismissible: isDismissible,
      enableDrag: isDrag,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius.r),
          topRight: Radius.circular(radius.r),
        ),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height - paddingTop.r,
      ),
      backgroundColor: CustomStyle.transparent,
      context: context,
      builder: (context) => modal,
    );
  }

  static void showCustomModalBottomSheetDrag({
    required BuildContext context,
    required Function(ScrollController controller) modal,
    double radius = 24,
    bool isDrag = true,
    bool isDismissible = true,
    double paddingTop = 200,
    double maxChildSize = 0.9,
  }) {
    showModalBottomSheet(
      isDismissible: isDismissible,
      enableDrag: isDrag,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius.r),
          topRight: Radius.circular(radius.r),
        ),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height - paddingTop.r,
      ),
      backgroundColor: CustomStyle.transparent,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: maxChildSize,
        maxChildSize: maxChildSize,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return modal(scrollController);
        },
      ),
    );
  }

  static addProduct(
      {required BuildContext context,
      required ProductData? product,
      required Stocks? stock}) {
    if ((stock?.quantity ?? 0) <= 0) {
      Vibration.vibrate();
      openDialog(context: context, title: getTranslation(TrKeys.errorQuantity));
      return;
    }
    Vibration.vibrate();
    int count = getCountCart(productId: product?.id, stockId: stock?.id);
    String? image;
    stock?.extras?.forEach((element) {
      if (element.group?.type == "color") {
        image = checkIfImage(element.value, product?.stocks)?.path;
        return;
      }
    });
    if (count >= (product?.maxQty ?? 100)) {
      openDialog(
          context: context,
          title: "${getTranslation(TrKeys.errorMaxQty)} $count");
      return;
    }
    if (count >= (stock?.quantity ?? 100)) {
      openDialog(
          context: context,
          title: "${getTranslation(TrKeys.errorQuantity)} $count");
      return;
    }
    if ((stock?.quantity ?? 100) <=
        count + (count != 0 ? 1 : product?.minQty ?? 1)) {
      LocalStorage.setCartList(
          productId: product?.id,
          stockId: stock?.id,
          image: image,
          count: count + (count != 0 ? 1 : stock?.quantity ?? 1));
      context.read<ProductBloc>().add(const ProductEvent.updateState());
      context.read<CartBloc>().add(const CartEvent.updateState());

      return;
    }

    LocalStorage.setCartList(
        productId: product?.id,
        stockId: stock?.id,
        image: image,
        count: count +
            (count != 0
                ? 1
                : (product?.minQty ?? 1) == 0
                    ? 1
                    : (product?.minQty ?? 1)));
    context.read<ProductBloc>().add(const ProductEvent.updateState());
    context.read<CartBloc>().add(const CartEvent.updateState());
  }

  static removeProduct(
      {required BuildContext context,
      required ProductData? product,
      required Stocks? stock}) {
    Vibration.vibrate();
    int count = getCountCart(productId: product?.id, stockId: stock?.id);
    if (count <= (product?.minQty ?? 1)) {
      LocalStorage.setCartList(
          productId: product?.id, stockId: stock?.id, count: 0);
      context.read<ProductBloc>().add(const ProductEvent.updateState());
      context.read<CartBloc>().add(const CartEvent.updateState());
      return;
    }
    LocalStorage.setCartList(
        productId: product?.id, stockId: stock?.id, count: count - 1);
    context.read<ProductBloc>().add(const ProductEvent.updateState());
    context.read<CartBloc>().add(const CartEvent.updateState());
  }

  static deleteProduct(
      {required BuildContext context,
      required ProductData? product,
      required Stocks? stock}) {
    Vibration.vibrate();
    LocalStorage.setCartList(
        productId: product?.id, stockId: stock?.id, count: 0);
    context.read<ProductBloc>().add(const ProductEvent.updateState());
    context.read<CartBloc>().add(const CartEvent.updateState());
  }

  static String getAppName() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'title') {
        return setting.value ?? "";
      }
    }
    return '';
  }

  static num getCommission() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'commission') {
        return num.tryParse(setting.value ?? "0") ?? 0;
      }
    }
    return 0;
  }

  static bool getProductUiType() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'product_ui_type') {
        return setting.value == "2";
      }
    }
    return true;
  }

  static bool getGroupOrder() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'group_order') {
        return setting.value == "1";
      }
    }
    return true;
  }

  static int getCartUiType() {
    // final List<SettingsData> settings = LocalStorage.getSettingsList();
    // for (final setting in settings) {
    //   if (setting.key == 'cart_ui_type') {
    //     return (int.tryParse(setting.value ?? "1") ?? 1);
    //   }
    // }
    return 2;
  }

  static int getOrderUiType() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'order_ui_type') {
        return (int.tryParse(setting.value ?? "1") ?? 1);
      }
    }
    return 1;
  }

  static int getType() {
    // if (AppConstants.isDemo) {
    //   return LocalStorage.getUiType() ?? 0;
    // }
    // final List<SettingsData> settings = LocalStorage.getSettingsList();
    // for (final setting in settings) {
    //   if (setting.key == 'ui_type') {
    //     return (int.tryParse(setting.value ?? "1") ?? 1) - 1;
    //   }
    // }
    return 0;
  }

  static String getTranslation(String trKey) {
    final Map<String, dynamic> translations = LocalStorage.getTranslations();
    if (AppConstants.autoTrn) {
      return (translations[trKey] ??
          (trKey.isNotEmpty
              ? trKey.replaceAll(".", " ").replaceAll("_", " ").replaceFirst(
                  trKey.substring(0, 1), trKey.substring(0, 1).toUpperCase())
              : ''));
    } else {
      return translations[trKey] ?? trKey;
    }
  }

  static bool productInclude({required int? productId, required int? stockId}) {
    final list = LocalStorage.getCartList();
    for (var element in list) {
      if (element.productId == productId && element.stockId == stockId) {
        if (element.count <= 0) {
          return false;
        }
        return true;
      }
    }
    return false;
  }

  static int getCountCart({required int? productId, required int? stockId}) {
    final list = LocalStorage.getCartList();
    for (var element in list) {
      if (element.productId == productId && element.stockId == stockId) {
        return element.count;
      }
    }
    return 0;
  }

  static RichText getSearchResultText(
      String mainText, String subtext, CustomColorSet colors) {
    if (!mainText.toUpperCase().contains(subtext.toUpperCase())) {
      return RichText(
        text: TextSpan(
          text: mainText,
          style: CustomStyle.interNormal(
              color: colors.textBlack.withOpacity(0.3), size: 14),
        ),
      );
    }
    final int startIndex =
        mainText.toUpperCase().indexOf(subtext.toUpperCase());
    final String prefixText = mainText.substring(0, startIndex);
    final String centerText =
        mainText.substring(startIndex, startIndex + subtext.length);
    final hasPostText = subtext.length + startIndex <= mainText.length - 1;
    final String postText = hasPostText
        ? mainText.substring(subtext.length + startIndex, mainText.length)
        : '';
    return RichText(
      text: TextSpan(
        text: prefixText,
        style: CustomStyle.interNormal(
            color: colors.textBlack.withOpacity(0.3), size: 14),
        children: <TextSpan>[
          TextSpan(
            text: centerText,
            style: CustomStyle.interNormal(color: colors.textBlack, size: 14),
          ),
          TextSpan(
            text: postText,
            style: CustomStyle.interNormal(
                color: colors.textBlack.withOpacity(0.3), size: 14),
          ),
        ],
      ),
    );
  }

  static bool checkPhone(String value) {
    String pattern = r'^[0-9]+$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value.replaceAll("+", ""));
  }

  static ExtrasType getExtraTypeByValue(String? value) {
    switch (value) {
      case 'color':
        return ExtrasType.color;
      case 'text':
        return ExtrasType.text;
      case 'image':
        return ExtrasType.image;
      default:
        return ExtrasType.text;
    }
  }

  static bool checkIfHex(String? type) {
    if (type == null || type.isEmpty) {
      return false;
    }
    if (type.length == 7 && type[0] == '#') {
      return true;
    } else {
      return false;
    }
  }

  static bool checkAvif(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }
    if (url.contains('.avif')) {
      return true;
    } else {
      return false;
    }
  }

  static String getNameColor(String? value) {
    if (checkIfHex(value)) {
      final color = Color(int.parse('0xFF${value?.substring(1, 7)}'));
      return color.colorName;
    }
    return value ?? TrKeys.unKnow;
  }

  static Galleries? checkIfImage(String? value, List<Stocks>? stocks) {
    Galleries? galleries;
    stocks?.forEach((element) {
      element.extras?.forEach((e) {
        if (e.value == value) {
          if (element.galleries?.isNotEmpty ?? false) {
            galleries = element.galleries?.first;
            return;
          }
        }
      });
    });
    return galleries;
  }

  static double getInitialLatitude() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'location') {
        final String? latString =
            setting.value?.substring(0, setting.value?.indexOf(','));
        if (latString == null) {
          return AppConstants.demoLatitude;
        }
        final double? lat = double.tryParse(latString);
        return lat ?? AppConstants.demoLatitude;
      }
    }
    return AppConstants.demoLatitude;
  }

  static double getInitialLongitude() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'location') {
        final String? latString =
            setting.value?.substring(0, setting.value?.indexOf(','));
        if (latString == null) {
          return AppConstants.demoLongitude;
        }
        final String? lonString = setting.value
            ?.substring((latString.length) + 2, setting.value?.length);
        if (lonString == null) {
          return AppConstants.demoLatitude;
        }
        final double lon = double.parse(lonString);
        return lon;
      }
    }
    return AppConstants.demoLatitude;
  }

  static bool getParcel() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'active_parcel') {
        return setting.value == "1";
      }
    }
    return true;
  }

  static bool getBlog() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'blog_active') {
        return setting.value == "1";
      }
    }
    return true;
  }

  static num getMinAmount() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'min_amount') {
        return num.tryParse(setting.value ?? "0") ?? 0;
      }
    }
    return 0;
  }

  static bool getReferralActive() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'referral_active') {
        return setting.value == "1";
      }
    }
    return false;
  }

  static String getFilterType(FilterType value) {
    switch (value) {
      case FilterType.news:
        return "new";
      case FilterType.priceMin:
        return "price_min";
      case FilterType.priceMax:
        return "price_max";
      case FilterType.mostSold:
        return "most_sold";

      default:
        return value.name;
    }
  }

  static OrderStatus getOrderStatus(String? value) {
    switch (value) {
      case 'new':
      case 'accepted':
        return OrderStatus.accepted;
      case 'ready':
        return OrderStatus.ready;
      case 'on_a_way':
        return OrderStatus.onWay;
      case 'delivered':
        return OrderStatus.delivered;
      case 'canceled':
        return OrderStatus.canceled;
      default:
        return OrderStatus.accepted;
    }
  }

  static int getOrderStatusForNumber(String? value) {
    switch (value) {
      case 'new':
        return 6;
      case 'accepted':
        return 5;
      case 'ready':
        return 4;
      case 'on_a_way':
        return 3;
      case 'pause':
        return 2;
      case 'delivered':
        return 1;
      case 'canceled':
        return 0;
      default:
        return 6;
    }
  }

  static String formatHHMMSS(int seconds) {
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  static String shopTime(List<WorkingDay>? days, bool? open) {
    String time = getTranslation(TrKeys.closed);
    if (open ?? true) {
      days?.forEach((element) {
        if (element.day?.toLowerCase() ==
            DateFormat("EEEE").format(DateTime.now()).toLowerCase()) {
          if (!(element.disabled ?? false)) {
            time = "${element.from ?? "01:00"} - ${element.to ?? "23:00"}";
          }
          return;
        }
      });
    }

    return time;
  }

  static String? findLowPriceStocks(List<Stocks>? stocks) {
    if (stocks?.isEmpty ?? true) {
      return numberFormat(0);
    }
    num price = stocks?.first.price ?? 0;
    stocks?.forEach((element) {
      if ((element.price ?? 0) < price) {
        price = element.price ?? 0;
      }
    });
    return numberFormat(price);
  }
}
