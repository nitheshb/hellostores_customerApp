import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/infrastructure/model/model/shop_model.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class ShopItemPage extends StatelessWidget {
  final CustomColorSet colors;
  final ShopData shop;

  const ShopItemPage({super.key, required this.colors, required this.shop})
     ;

  @override
  Widget build(BuildContext context) {
    return ButtonEffectAnimation(
      onTap: () {
        AppRoute.goShopPage(context: context, shop: shop);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radius.r),
          border: Border.all(color: colors.icon),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(AppConstants.radius.r),
                  topLeft: Radius.circular(AppConstants.radius.r)),
              child: CustomNetworkImage(
                  url: shop.backgroundImg ?? shop.logoImg,
                  height: 170,
                  width: double.infinity,
                  radius: 0),
            ),
            16.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.r),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.translation?.title ?? "",
                        style: CustomStyle.interSemi(
                            color: colors.textBlack, size: 16),
                      ),
                      4.verticalSpace,
                      Text(
                        AppHelpers.shopTime(shop.workingDays, shop.open),
                        style: CustomStyle.interNormal(
                            color: colors.textHint, size: 14),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset("assets/svg/start.svg"),
                  4.horizontalSpace,
                  Text(
                    shop.rAvg?.toStringAsPrecision(2) ?? "0.0",
                    style: CustomStyle.interNoSemi(
                        color: colors.textBlack, size: 12),
                  )
                ],
              ),
            ),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }
}
