import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/infrastructure/model/response/filter_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class ExtrasItem extends StatelessWidget {
  final CustomColorSet colors;
  final String type;
  final Extra extra;
  final List<int> list;

  const ExtrasItem({
    super.key,
    required this.type,
    required this.extra,
    required this.colors,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return type == "color"
        ? AppHelpers.checkIfHex(extra.value)
            ? Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(4.r),
                        width: 36.r,
                        height: 36.r,
                        decoration: BoxDecoration(
                            color: Color(int.parse(
                                '0xFF${extra.value?.substring(1, 7)}')),
                            borderRadius:
                                BorderRadius.circular(AppConstants.radius.r)),
                        child: list.contains(extra.id)
                            ? Container(
                                width: 36.r,
                                height: 36.r,
                                alignment: Alignment.center,
                                child: Icon(
                                  FlutterRemix.check_double_line,
                                  color:
                                      extra.value?.substring(1, 7) == "ffffff"
                                          ? CustomStyle.black
                                          : CustomStyle.white,
                                ),
                              )
                            : SizedBox(width: 36.r, height: 36.r),
                      ),
                      6.horizontalSpace,
                      Text(
                        AppHelpers.getNameColor(extra.value ?? ""),
                        style: CustomStyle.interNormal(
                          size: 14,
                          color: colors.textBlack,
                        ),
                      ),
                    ],
                  ),
                  Divider(color: colors.icon)
                ],
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radius.r),
                ),
                padding: REdgeInsets.all(12),
                child: Text(
                  extra.value ?? "",
                  style: CustomStyle.interNormal(
                    size: 14,
                    color: colors.textBlack,
                  ),
                ),
              )
        : Column(
            children: [
              4.verticalSpace,
              Row(
                children: [
                  Icon(
                    list.contains(extra.id)
                        ? FlutterRemix.checkbox_fill
                        : FlutterRemix.checkbox_blank_line,
                    color: list.contains(extra.id)
                        ? colors.primary
                        : colors.textBlack,
                  ),
                  10.horizontalSpace,
                  Text(
                    extra.value ?? "",
                    style: CustomStyle.interNormal(
                      size: 14,
                      color: colors.textBlack,
                    ),
                  )
                ],
              ),
              4.verticalSpace,
              Divider(color: colors.icon)
            ],
          );
  }
}
