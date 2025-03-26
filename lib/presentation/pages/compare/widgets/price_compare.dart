import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class PriceCompare extends StatelessWidget {
  final CustomColorSet colors;
  final ProductData product;

  const PriceCompare({super.key, required this.colors, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${AppHelpers.getTranslation(TrKeys.from)} ${AppHelpers.findLowPriceStocks(product.stocks)}",
            style: CustomStyle.interNormal(color: colors.textBlack,size: 15),
          ),
          4.verticalSpace,
          Text(
            "${product.stocks?.length ?? 0} ${AppHelpers.getTranslation(TrKeys.options)}",
            style: CustomStyle.interNormal(color: CustomStyle.seeAllColor,size: 14),
          ),
        ],
      ),
    );
  }
}
