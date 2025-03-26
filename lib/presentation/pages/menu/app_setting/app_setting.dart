import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'package:goshops/presentation/style/theme/theme_wrapper.dart';

import '../profile/widgets/button_item.dart';

class AppSettingPage extends StatelessWidget {
  const AppSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: (colors) => SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                PopButton(color: colors.textBlack),
                8.horizontalSpace,
                Text(
                  AppHelpers.getTranslation(TrKeys.appSetting),
                  style: CustomStyle.interNoSemi(
                      color: colors.textBlack, size: 18),
                ),
              ],
            ),
            24.verticalSpace,
            ButtonItem(
                icon: FlutterRemix.global_line,
                title: AppHelpers.getTranslation(TrKeys.language),
                selectValue: LocalStorage.getLanguage()?.title,
                onTap: () {
                  AppRoute.goLanguage(context: context);
                },
                colors: colors),
            ButtonItem(
                icon: FlutterRemix.money_dollar_circle_line,
                title: AppHelpers.getTranslation(TrKeys.currency),
                selectValue: LocalStorage.getSelectedCurrency()?.symbol,
                onTap: () {
                  AppRoute.goCurrency(context: context);
                },
                colors: colors),
            ThemeWrapper(builder: (colors, controller) {
              return ButtonItem(
                  icon: FlutterRemix.sun_line,
                  title: AppHelpers.getTranslation(TrKeys.appTheme),
                  onTap: () {
                    controller.toggle();
                  },
                  value: !controller.mode.isDark,
                  colors: colors);
            }),
            ButtonItem(
                icon: FlutterRemix.notification_line,
                title: AppHelpers.getTranslation(TrKeys.getNotification),
                onTap: () {
                  if (LocalStorage.getToken().isNotEmpty) {
                    userRepository.updateNotification(
                        notifications: LocalStorage.getUser().notification);
                  }
                },
                value: ((LocalStorage.getUser().notification?.isNotEmpty ??
                            false)
                        ? (LocalStorage.getUser().notification?.first.active ??
                            1)
                        : 1) ==
                    1,
                onTitle: AppHelpers.getTranslation(TrKeys.on),
                offTitle: AppHelpers.getTranslation(TrKeys.off),
                colors: colors),
          ],
        ),
      ),
      floatingButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingButton: (colors) => ButtonEffectAnimation(
        onTap: () {
          if (LocalStorage.getToken().isEmpty) {
            AppRoute.goLogin(context);
            return;
          }
          AppRoute.goChat(
            context: context,
            senderId: LocalStorage.getAdminId(),
          );
        },
        child: Container(
          width: double.infinity,
          margin: REdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.symmetric(vertical: 14.r, horizontal: 28.r),
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(AppConstants.radius.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FlutterRemix.message_3_fill,
                color: colors.white,
              ),
              10.horizontalSpace,
              Text(
                AppHelpers.getTranslation(TrKeys.onlineChat),
                style:
                    CustomStyle.interNoSemi(color: CustomStyle.white, size: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
