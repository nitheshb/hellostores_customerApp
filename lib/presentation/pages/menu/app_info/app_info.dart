import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/pages/menu/profile/widgets/button_item.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

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
                  AppHelpers.getTranslation(TrKeys.aboutThisApp),
                  style: CustomStyle.interNoSemi(
                      color: colors.textBlack, size: 18),
                ),
              ],
            ),
            24.verticalSpace,
            ButtonItem(
              colors: colors,
              icon: FlutterRemix.error_warning_line,
              title: AppHelpers.getTranslation(TrKeys.helpInfo),
              onTap: () {
                AppRoute.goHelp(context: context);
              },
            ),
            ButtonItem(
              colors: colors,
              icon: FlutterRemix.alarm_warning_line,
              title: AppHelpers.getTranslation(TrKeys.privacy),
              onTap: () {
                AppRoute.goPolicy(context: context);
              },
            ),
            ButtonItem(
              colors: colors,
              icon: FlutterRemix.spam_line,
              title: AppHelpers.getTranslation(TrKeys.terms),
              onTap: () {
                AppRoute.goTerm(context: context);
              },
            ),
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
