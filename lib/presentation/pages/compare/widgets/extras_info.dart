import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class ExtrasInfo extends StatelessWidget {
  final CustomColorSet colors;
  final GroupProperties properties;
  final ProductData product;

  const ExtrasInfo({
    super.key,
    required this.colors,
    required this.properties,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    Set<String> extra = {};
    bool isColor = properties.type == "color";

    for (int i = 0; i < (properties.values?.length ?? 0); i++) {
      if (properties.values?[i][product.id] != null) {
        extra.add(properties.values?[i][product.id] ?? "");
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
          8.verticalSpace,
          extra.isNotEmpty
              ? Wrap(
                  children: extra.map((value) {
                  return value.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.all(2.r),
                          height: 26.r,
                          width: isColor ? 24.r : 40.r,
                          decoration: BoxDecoration(
                              color: isColor
                                  ? AppHelpers.checkIfHex(value)
                                      ? Color(int.parse(
                                          '0xFF${value.substring(1, 7)}'))
                                      : colors.primary
                                  : colors.transparent,
                              border: Border.all(color: colors.textHint),
                              borderRadius: BorderRadius.circular(4.r)),
                          child: isColor
                              ? null
                              : Center(
                                  child: Text(
                                  value,
                                  style: CustomStyle.interNormal(
                                    color: colors.textBlack,
                                    size: 14,
                                  ),
                                )),
                        )
                      : const SizedBox.shrink();
                }).toList())
              : Text(
                  "- - -",
                  style: CustomStyle.interNormal(color: colors.textBlack),
                ),
        ],
      ),
    );
  }
}
