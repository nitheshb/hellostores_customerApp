import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class ProductInfo extends StatelessWidget {
  final CustomColorSet colors;
  final ProductData product;
  final double width;
  final List<Extras> listExtra;

  const ProductInfo({
    super.key,
    required this.product,
    required this.colors,
    this.width = 100,
    required this.listExtra,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          4.verticalSpace,
          SizedBox(
            height: 40.r,
            child: Text(
              product.translation?.title ?? "",
              style: CustomStyle.interNormal(color: colors.textBlack, size: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // if ((product.ratingAvg ?? 0) == 0)
          //   Text(
          //     AppHelpers.getTranslation(TrKeys.newKey),
          //     style: CustomStyle.interNormal(color: colors.textHint, size: 12),
          //   )
          // else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset("assets/svg/start.svg"),
              4.horizontalSpace,
              Text(
                product.ratingAvg?.toStringAsPrecision(2) ?? "0.0",
                style:
                    CustomStyle.interNormal(color: colors.textHint, size: 12),
              ),
              4.horizontalSpace,
              Text(
                '(${product.ratingCount ?? 0} ${AppHelpers.getTranslation(TrKeys.reviews).toLowerCase()})',
                style: CustomStyle.interNormal(
                  size: 12,
                  color: colors.textHint,
                  letterSpacing: -0.35,
                ),
              )
            ],
          ),
          if (product.stocks?.isNotEmpty ?? false)
            Container(
              height: 50.r,
              alignment: Alignment.bottomLeft,
              child: AppHelpers.numberFormat(product.stocks?.first.price ?? 0)
                          .length <
                      9
                  ? Row(
                      children: [
                        Text(
                          AppHelpers.numberFormat(
                              product.stocks?.first.totalPrice ?? 0),
                          style: CustomStyle.interSemi(
                              color: colors.textBlack, size: 16),
                        ),
                        if (product.stocks?.first.discount != null)
                          Padding(
                            padding: EdgeInsets.only(left: 10.r),
                            child: Text(
                              AppHelpers.numberFormat(
                                  (product.stocks?.first.totalPrice ?? 0) +
                                      product.stocks?.first.discount),
                              style: CustomStyle.interSemi(
                                  color: CustomStyle.red,
                                  size: 14,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (product.stocks?.first.discount != null)
                          Padding(
                            padding: EdgeInsets.only(right: 8.r),
                            child: Text(
                              AppHelpers.numberFormat(
                                  product.stocks?.first.price ?? 0),
                              style: CustomStyle.interSemi(
                                  color: CustomStyle.red,
                                  size: 13,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ),
                        Text(
                          AppHelpers.numberFormat(
                              product.stocks?.first.totalPrice ?? 0),
                          style: CustomStyle.interSemi(
                              color: colors.textBlack, size: 15),
                        ),
                      ],
                    ),
            ),
          if (product.stocks?.isEmpty ?? true)
            Text(
              AppHelpers.getTranslation(TrKeys.outOfStock),
              style: CustomStyle.interSemi(color: colors.textBlack, size: 18),
            ),
          2.verticalSpace,
        ],
      ),
    );
  }
}
