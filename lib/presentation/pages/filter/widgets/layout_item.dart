import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/presentation/pages/filter/widgets/layout_box.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';

class LayoutItem extends StatelessWidget {
  final CustomColorSet colors;
  final LayoutType type;
  final LayoutType selectType;

  const LayoutItem({
    super.key,
    required this.colors,
    required this.type,
    required this.selectType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: REdgeInsets.only(right: 16),
      foregroundDecoration: type == LayoutType.newUi
          ? RotatedCornerDecoration.withColor(
              color: CustomStyle.red,
              badgeSize: Size(24.r, 24.r),
              textSpan: TextSpan(
                text: AppHelpers.getTranslation(TrKeys.newKey),
                style:
                    CustomStyle.interNormal(color: CustomStyle.white, size: 8),
              ),
            )
          : null,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radius.r),
          border: Border.all(color: colors.white),
          color: CustomStyle.transparent),
      padding: REdgeInsets.all(6),
      child: type == LayoutType.twoH
          ? Row(
              children: [
                LayoutBox(
                  active: selectType == LayoutType.twoH,
                  width: 14,
                ),
                4.horizontalSpace,
                LayoutBox(
                  active: selectType == LayoutType.twoH,
                  width: 14,
                ),
              ],
            )
          : type == LayoutType.three
              ? Column(
                  children: [
                    Row(
                      children: [
                        LayoutBox(
                          active: selectType == LayoutType.three,
                          height: 14,
                          width: 8,
                          radius: 2,
                        ),
                        4.horizontalSpace,
                        LayoutBox(
                          active: selectType == LayoutType.three,
                          height: 14,
                          width: 8,
                          radius: 2,
                        ),
                        4.horizontalSpace,
                        LayoutBox(
                          active: selectType == LayoutType.three,
                          height: 14,
                          width: 8,
                          radius: 2,
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    Row(
                      children: [
                        LayoutBox(
                          active: selectType == LayoutType.three,
                          height: 14,
                          width: 8,
                          radius: 2,
                        ),
                        4.horizontalSpace,
                        LayoutBox(
                          active: selectType == LayoutType.three,
                          height: 14,
                          width: 8,
                          radius: 2,
                        ),
                        4.horizontalSpace,
                        LayoutBox(
                          active: selectType == LayoutType.three,
                          height: 14,
                          width: 8,
                          radius: 2,
                        ),
                      ],
                    ),
                  ],
                )
              : type == LayoutType.twoV
                  ? Column(
                      children: [
                        LayoutBox(
                          active: selectType == LayoutType.twoV,
                          height: 14,
                          width: 32,
                        ),
                        4.verticalSpace,
                        LayoutBox(
                          active: selectType == LayoutType.twoV,
                          height: 14,
                          width: 32,
                        ),
                      ],
                    )
                  : type == LayoutType.one
                      ? LayoutBox(
                          active: selectType == LayoutType.one,
                          height: 32,
                          width: 32,
                        )
                      : Icon(
                          FlutterRemix.collage_fill,
                          size: 32.r,
                          color: selectType == LayoutType.newUi
                              ? CustomStyle.primary
                              : CustomStyle.unselectLayout,
                        ),
    );
  }
}
