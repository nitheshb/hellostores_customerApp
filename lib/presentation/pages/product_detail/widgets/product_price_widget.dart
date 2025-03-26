import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/app_assets.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductPriceWidget extends StatelessWidget {
  final Stocks? selectedStock;
  final CustomColorSet colors;

  const ProductPriceWidget({
    super.key,
    this.selectedStock,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount =
        selectedStock?.discount != null && (selectedStock!.discount ?? 0) > 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              AppHelpers.numberFormat(selectedStock?.totalPrice),
              style: CustomStyle.interNoSemi(
                size: 18,
                color: colors.textBlack,
                letterSpacing: -0.35,
              ),
            ),
            if (hasDiscount)
              Row(
                children: [
                  10.horizontalSpace,
                  Container(
                    width: 4.r,
                    height: 4.r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.r),
                      color: colors.textBlack.withOpacity(0.2),
                    ),
                  ),
                  6.horizontalSpace,
                  Text(
                    AppHelpers.numberFormat((selectedStock!.totalPrice ?? 0) + (selectedStock?.discount ?? 0)),
                    style: CustomStyle.interNoSemi(
                      size: 18,
                      color: CustomStyle.red,
                      letterSpacing: -0.35,
                    ),
                  ),
                ],
              ),
          ],
        ),
        if (hasDiscount)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
              color: CustomStyle.red,
            ),
            padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.svgDiscount,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    colors.newBoxColor,
                    BlendMode.srcIn,
                  ),
                ),
                4.horizontalSpace,
                Text(
                  '${AppHelpers.getTranslation(TrKeys.sale)} ${(((selectedStock?.discount ?? 0) / (selectedStock?.price ?? 1)) * 100).toInt()}%',
                  style: CustomStyle.interSemi(
                    size: 12,
                    color: colors.newBoxColor,
                    letterSpacing: -0.35,
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}
