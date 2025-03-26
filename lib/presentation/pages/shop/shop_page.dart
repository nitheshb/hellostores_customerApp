import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/pages/shop/widgets/connect_button.dart';
import 'package:goshops/presentation/pages/shop/widgets/most_products_shop.dart';
import 'package:goshops/presentation/pages/shop/widgets/new_products_shop.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'widgets/shop_avatar.dart';

class ShopPage extends StatelessWidget {
  final int? shopId;

  const ShopPage({super.key, required this.shopId});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: (colors) => Stack(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (BuildContext context, bool innerBox) {
                return [
                  SliverAppBar(
                    pinned: true,
                    snap: false,
                    floating: true,
                    forceElevated: true,
                    expandedHeight: 250.r,
                    toolbarHeight: 56.r,
                    elevation: 0,
                    leading: const SizedBox.shrink(),
                    backgroundColor: colors.backgroundColor,
                    flexibleSpace: FlexibleSpaceBar(
                      expandedTitleScale: 1.5,
                      collapseMode: CollapseMode.pin,
                      title: ShopName(colors: colors),
                      titlePadding: EdgeInsets.only(
                        top: MediaQuery.paddingOf(context).top + 10.r,
                      ),
                      background: ShopAvatar(colors: colors),
                    ),
                  )
                ];
              },
              body: SizedBox(
                height: MediaQuery.sizeOf(context).height - 250.r,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    MostShopProductList(
                      colors: colors,
                      shopId: shopId,
                    ),
                    NewShopsProductList(
                      colors: colors,
                      shopId: shopId,
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.paddingOf(context).top + 4,
                left: 14.r,
                right: 14.r),
            child: Row(
              children: [
                BlurWrap(
                  radius: BorderRadius.circular(32.r),
                  child: Container(
                    color: colors.white.withOpacity(0.2),
                    child: PopButton(color: colors.textBlack),
                  ),
                ),
                const Spacer(),
                BlurWrap(
                  radius: BorderRadius.circular(AppConstants.radius.r),
                  child: Container(
                    color: colors.white.withOpacity(0.2),
                    child: IconButton(
                        onPressed: () {
                          AppRoute.goSearchPage(
                              context: context, shopId: shopId);
                        },
                        icon: Icon(
                          FlutterRemix.search_2_line,
                          color: colors.textBlack,
                        )),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      floatingButton: (colors) => ConnectButtonShop(colors: colors),
    );
  }
}
