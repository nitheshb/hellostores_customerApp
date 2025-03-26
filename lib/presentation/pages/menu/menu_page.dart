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
import 'package:goshops/presentation/style/theme/theme_wrapper.dart';
import 'widgets/drawer_item.dart';
import 'widgets/logout_button.dart';
import 'widgets/wallet_widget.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: (colors) => ThemeWrapper(
        builder: (colors, controller) {
          return KeyboardDismisser(
            isLtr: LocalStorage.getLangLtr(),
            child: ListView(
              padding: REdgeInsets.symmetric(horizontal: 20, vertical: 32),
              shrinkWrap: true,
              children: [
                12.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        FlutterRemix.close_line,
                        size: 24.r,
                        color: colors.textBlack,
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                LogoutButton(colors: colors),
                16.verticalSpace,
                if (LocalStorage.getToken().isNotEmpty)
                  WalletScreen(colors: colors),
                24.verticalSpace,
                Text(
                  AppHelpers.getTranslation(TrKeys.information).toUpperCase(),
                  style: CustomStyle.interNormal(
                      color: colors.textBlack, size: 12),
                ),
                DrawerItem(
                  colors: colors,
                  icon: FlutterRemix.heart_3_line,
                  title: AppHelpers.getTranslation(TrKeys.myWishlist),
                  onTap: () {
                    AppRoute.goLikePage(context: context);
                  },
                ),
                if (LocalStorage.getToken().isNotEmpty)
                  DrawerItem(
                    colors: colors,
                    icon: FlutterRemix.user_settings_line,
                    title: AppHelpers.getTranslation(TrKeys.myAccount),
                    onTap: () {
                      AppRoute.goMyAccount(context: context);
                    },
                  ),
                if (AppConstants.isDemo)
                  DrawerItem(
                    colors: colors,
                    icon: FlutterRemix.magic_line,
                    title: AppHelpers.getTranslation(TrKeys.selectUiType),
                    onTap: () {
                      AppRoute.goSelectUIType(context: context);
                    },
                  ),

                if (LocalStorage.getToken().isNotEmpty)
                  DrawerItem(
                    colors: colors,
                    icon: FlutterRemix.file_list_2_line,
                    title: AppHelpers.getTranslation(TrKeys.orderHistory),
                    onTap: () {
                      AppRoute.goOrdersList(context: context);
                    },
                  ),
                if (LocalStorage.getToken().isNotEmpty &&
                    AppHelpers.getParcel())
                  DrawerItem(
                    colors: colors,
                    icon: FlutterRemix.archive_line,
                    title: AppHelpers.getTranslation(TrKeys.parcel),
                    onTap: () {
                      AppRoute.goParcel(context: context);
                    },
                  ),
                if (LocalStorage.getToken().isNotEmpty &&
                    AppHelpers.getParcel())
                  DrawerItem(
                    colors: colors,
                    icon: FlutterRemix.archive_drawer_line,
                    title: AppHelpers.getTranslation(TrKeys.parcelHistory),
                    onTap: () {
                      AppRoute.goParcelList(context: context);
                    },
                  ),
                if (LocalStorage.getToken().isNotEmpty)
                  DrawerItem(
                    colors: colors,
                    icon: FlutterRemix.file_list_3_line,
                    title: AppHelpers.getTranslation(TrKeys.myDigitalList),
                    onTap: () {
                      AppRoute.goMyDigitalList(context: context);
                    },
                  ),

                if (LocalStorage.getToken().isNotEmpty)
                  DrawerItem(
                    colors: colors,
                    icon: FlutterRemix.stack_line,
                    title: AppHelpers.getTranslation(TrKeys.compare),
                    onTap: () {
                      AppRoute.goComparePage(context: context);
                    },
                  ),
                DrawerItem(
                  colors: colors,
                  icon: FlutterRemix.archive_line,
                  title: AppHelpers.getTranslation(TrKeys.categories),
                  onTap: () {
                    AppRoute.goCategoryListPage(context: context);
                  },
                ),
                if (LocalStorage.getToken().isNotEmpty &&
                    AppHelpers.getReferralActive())
                  DrawerItem(
                    colors: colors,
                    icon: FlutterRemix.money_dollar_circle_line,
                    title: AppHelpers.getTranslation(TrKeys.inviteFriend),
                    onTap: () {
                      AppRoute.goMyReferral(context: context);
                    },
                  ),
                if (AppHelpers.getBlog())
                  DrawerItem(
                    colors: colors,
                    icon: FlutterRemix.message_3_line,
                    title: AppHelpers.getTranslation(TrKeys.blog),
                    onTap: () {
                      AppRoute.goBlog(context: context);
                    },
                  ),
                if (LocalStorage.getToken().isNotEmpty)
                  DrawerItem(
                    colors: colors,
                    icon: FlutterRemix.store_2_line,
                    title: AppHelpers.getTranslation(TrKeys.becomeSeller),
                    onTap: () {
                      AppRoute.goBecomeSeller(context: context);
                    },
                  ),
                if (LocalStorage.getToken().isNotEmpty &&
                    AppHelpers.getGroupOrder())
                  DrawerItem(
                    colors: colors,
                    icon: FlutterRemix.team_line,
                    title: AppHelpers.getTranslation(TrKeys.groupOrder),
                    onTap: () {
                      AppRoute.goGroupOrder(context, colors);
                    },
                  ),
                24.verticalSpace,
                Text(
                  AppHelpers.getTranslation(TrKeys.setting).toUpperCase(),
                  style: CustomStyle.interNormal(
                      color: colors.textBlack, size: 12),
                ),
                DrawerItem(
                  colors: colors,
                  icon: FlutterRemix.settings_3_line,
                  title: AppHelpers.getTranslation(TrKeys.appSetting),
                  onTap: () {
                    AppRoute.goAppSetting(context: context);
                  },
                ),
                if (LocalStorage.getToken().isNotEmpty)
                  DrawerItem(
                    colors: colors,
                    icon: FlutterRemix.customer_service_2_line,
                    title: AppHelpers.getTranslation(TrKeys.chats),
                    onTap: () {
                      AppRoute.goChatsList(context: context);
                    },
                  ),
                DrawerItem(
                  colors: colors,
                  icon: FlutterRemix.error_warning_line,
                  title: AppHelpers.getTranslation(TrKeys.aboutThisApp),
                  onTap: () {
                    AppRoute.goAboutThisApp(context: context);
                  },
                ),

                if (LocalStorage.getToken().isNotEmpty)
                  DrawerItem(
                    colors: colors,
                    icon: FlutterRemix.logout_circle_line,
                    title: AppHelpers.getTranslation(TrKeys.logout),
                    onTap: () {
                      AppRoute.goLogin(context);
                      authRepository.logout();
                    },
                  ),
                // 16.verticalSpace,
                // ChangeThemeButton(
                //   colors: colors,
                //   controller: controller,
                // )
              ],
            ),
          );
        },
      ),
    );
  }
}
