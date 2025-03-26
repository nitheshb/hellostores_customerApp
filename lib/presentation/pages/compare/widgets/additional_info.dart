import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class AdditionalInfo extends StatelessWidget {
  final CustomColorSet colors;
  final GroupProperties properties;
  final ProductData product;

  const AdditionalInfo({
    super.key,
    required this.colors,
    required this.properties,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    Set<String> extra = {};

    for (int i = 0;
    i < (properties.values?.length ?? 0);
    i++) {
      if (properties.values?[i][product.id] != null) {
        extra.add(
            properties.values?[i][product.id] ?? "");
      }
    }
    return Padding(
      padding: REdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            properties.translation?.title ?? "",
            style: CustomStyle.interRegular(color: colors.textHint),
          ),
          4.verticalSpace,
          extra.isNotEmpty
              ? Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: extra.map((value) {
                return value.isNotEmpty
                    ? Padding(
                  padding: EdgeInsets.all(4.r),
                  child: Text(
                    value,
                    style: CustomStyle.interNormal(
                        color: colors.textBlack),
                  ),
                )
                    : const SizedBox.shrink();
              }).toList())
              : Text(
            "- - -",
            style: CustomStyle.interNormal(
              color: colors.textBlack,
              size: 15,
            ),
          ),
          Divider(color: colors.newBoxColor, height: 8),
        ],
      ),
    );
  }
}
