import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/infrastructure/model/model/shop_model.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/app_assets.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

import 'custom_network_image.dart';

class MainShopItem extends StatelessWidget {
  final ShopData shop;
  final CustomColorSet colors;

  const MainShopItem({
    super.key,
    required this.shop,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radius.r),
          onTap: () {
            AppRoute.goShopPage(context: context, shop: shop);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.radius.r),
              border: Border.all(color: colors.icon),
            ),
            padding: REdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colors.newBoxColor,
                    borderRadius: BorderRadius.circular(AppConstants.radius.r),
                  ),
                  child: CustomNetworkImage(
                    url: shop.logoImg,
                    height: 40.r,
                    width: 40.r,
                    fit: BoxFit.cover,
                    radius: AppConstants.radius,
                  ),
                ),
                4.verticalSpace,
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        shop.translation?.title ?? '',
                        style: CustomStyle.interNoSemi(
                          color: colors.textBlack,
                          size: 16,
                        ),
                      ),
                    ),
                    6.horizontalSpace,
                    if (shop.verify ?? false)
                      Icon(
                        FlutterRemix.checkbox_circle_fill,
                        color: colors.textBlack,
                        size: 14.r,
                      ),
                    7.verticalSpace,
                  ],
                ),
                Row(
                  children: [
                    Text(
                      AppHelpers.shopTime(shop.workingDays, shop.open),
                      style: CustomStyle.interNormal(
                        color: colors.textBlack,
                        size: 14,
                      ),
                    ),
                    12.horizontalSpace,
                    Container(
                      width: 4.r,
                      height: 4.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.r),
                        color: CustomStyle.black.withOpacity(0.2),
                      ),
                    ),
                    12.horizontalSpace,
                    if ((shop.rAvg ?? 0) == 0)
                      Text(
                        AppHelpers.getTranslation(TrKeys.newKey),
                        style: CustomStyle.interNoSemi(
                            color: colors.textHint, size: 12),
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            FlutterRemix.star_fill,
                            color: CustomStyle.rate,
                            size: 16.r,
                          ),
                          4.horizontalSpace,
                          Text(
                            shop.rAvg?.toStringAsPrecision(2) ?? "0.0",
                            style: CustomStyle.interNoSemi(
                              color: colors.textBlack,
                              size: 14,
                            ),
                          ),
                          4.horizontalSpace,
                          Text(
                            '(${shop.rCount ?? ''} ${AppHelpers.getTranslation(TrKeys.reviews).toLowerCase()})',
                            style: CustomStyle.interNoSemi(
                              size: 14,
                              color: colors.textBlack,
                              letterSpacing: -0.35,
                            ),
                          )
                        ],
                      ),
                  ],
                ),
                19.verticalSpace,
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radius.r),
                        color: colors.newBoxColor,
                      ),
                      padding: REdgeInsets.all(2),
                      child: Row(
                        children: [
                          Container(
                            width: 28.r,
                            height: 28.r,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radius.r),
                              color: colors.primary,
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              Assets.svgIcDelivery,
                              width: 16.r,
                              height: 16.r,
                              colorFilter: const ColorFilter.mode(
                                CustomStyle.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          6.horizontalSpace,
                          Text(
                            AppHelpers.getTranslation(TrKeys.delivery),
                            style: CustomStyle.interNoSemi(
                              color: colors.textBlack,
                              size: 13,
                              letterSpacing: 0.1,
                            ),
                          ),
                          6.horizontalSpace,
                        ],
                      ),
                    ),
                    12.horizontalSpace,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radius.r),
                        color: colors.newBoxColor,
                      ),
                      padding: REdgeInsets.all(2),
                      child: Row(
                        children: [
                          Container(
                            width: 28.r,
                            height: 28.r,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radius.r),
                              color: CustomStyle.rate,
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              Assets.svgIcLocationStar,
                              width: 16.r,
                              height: 16.r,
                              colorFilter: const ColorFilter.mode(
                                CustomStyle.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          6.horizontalSpace,
                          Text(
                            AppHelpers.getTranslation(TrKeys.pickup),
                            style: CustomStyle.interNoSemi(
                              color: colors.textBlack,
                              size: 13,
                              letterSpacing: 0.1,
                            ),
                          ),
                          6.horizontalSpace,
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        10.verticalSpace,
      ],
    );
  }
}
