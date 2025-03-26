import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class CategoryInfo extends StatelessWidget {
  final CustomColorSet colors;
  final ProductData product;

  const CategoryInfo({super.key, required this.colors, required this.product});

  @override
  Widget build(BuildContext context) {
    return _category();
  }

  Widget _category() {
    return Padding(
      padding: REdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppHelpers.getTranslation(TrKeys.categories),
            style: CustomStyle.interRegular(color: colors.textHint),
          ),
          4.verticalSpace,
          Text(
            product.category?.translation?.title ?? "",
            style: CustomStyle.interNormal(color: colors.textBlack),
          ),
        ],
      ),
    );
  }
}

class BrandInfo extends StatelessWidget {
  final CustomColorSet colors;
  final ProductData product;

  const BrandInfo({super.key, required this.colors, required this.product});

  @override
  Widget build(BuildContext context) {
    return _brand();
  }

  Widget _brand() {
    return Padding(
      padding: REdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppHelpers.getTranslation(TrKeys.brand),
            style: CustomStyle.interRegular(color: colors.textHint),
          ),
          4.verticalSpace,
          Text(
            product.brand?.title ?? AppHelpers.getTranslation(TrKeys.noInfo),
            style: CustomStyle.interNormal(color: colors.textBlack),
          ),
        ],
      ),
    );
  }
}
