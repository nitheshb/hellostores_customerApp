import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/infrastructure/model/model/shop_model.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class ShopItem extends StatelessWidget {
  final ShopData? shop;
  final CustomColorSet colors;

  const ShopItem({
    super.key,
    this.shop,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          AppRoute.goShopPage(context: context, shop: shop);
        },
        child: Container(
          decoration: BoxDecoration(
            color: colors.newBoxColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.all(12.r),
          child: Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.r),
                  ),
                ),
                child: CustomNetworkImage(
                  url: shop?.logoImg ?? '',
                  width: 48.r,
                  height: 48.r,
                  radius: 8,
                  fit: BoxFit.cover,
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop?.translation?.title ??
                          AppHelpers.getTranslation(TrKeys.noTitle),
                      style: CustomStyle.interNormal(
                        color: colors.textBlack,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 1.5,
                      child: Text(
                        shop?.translation?.description ?? "",
                        style: CustomStyle.interRegular(
                          color: colors.textHint,
                          size: 12
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
