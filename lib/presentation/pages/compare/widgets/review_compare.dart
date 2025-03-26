import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

import 'package:goshops/infrastructure/service/helper.dart';
import 'package:goshops/infrastructure/service/tr_keys.dart';

class ReviewCompare extends StatelessWidget {
  final CustomColorSet colors;
  final ProductData product;

  const ReviewCompare({super.key, required this.colors, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            FlutterRemix.star_smile_fill,
            color: CustomStyle.rate,
            size: 18.r,
          ),
          4.horizontalSpace,
          Text(
            (product.ratingAvg ?? 0).toString(),
            style: CustomStyle.interNormal(color: colors.textBlack, size: 15),
          ),
          const Spacer(),
          Text(
            "${product.ratingCount ?? 0} ${AppHelpers.getTranslation(TrKeys.reviews)}",
            style: CustomStyle.interNormal(color: colors.textBlack, size: 14),
          ),
          4.horizontalSpace,
        ],
      ),
    );
  }
}
