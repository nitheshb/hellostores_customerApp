import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/product_detail/product_detail_bloc.dart';
import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/infrastructure/model/model/review_data.dart';
import 'package:goshops/infrastructure/model/model/typed_extra.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class ColorTwoExtras extends StatelessWidget {
  final int groupIndex;
  final List<UiExtra> uiExtras;
  final List<Stocks> stocks;
  final Function(UiExtra) onUpdate;
  final Stocks? selectStock;
  final CustomColorSet colors;

  const ColorTwoExtras({
    super.key,
    required this.groupIndex,
    required this.uiExtras,
    required this.onUpdate,
    required this.stocks,
    required this.selectStock,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.r,
      runSpacing: 10.r,
      children: uiExtras
          .map(
            (uiExtra) => (AppHelpers.checkIfImage(uiExtra.value, stocks) != null)
                ? Container(
                    foregroundDecoration: BoxDecoration(
                        color: (selectStock?.quantity ?? 0) <= 0 &&
                                uiExtra.isSelected
                            ? CustomStyle.white.withOpacity(0.7)
                            : CustomStyle.transparent),
                    child: ButtonEffectAnimation(
                      onTap: () {
                        if (uiExtra.isSelected) {
                          return;
                        }
                        onUpdate(uiExtra);
                        context.read<ProductDetailBloc>().add(
                            ProductDetailEvent.selectImage(
                                image: AppHelpers.checkIfImage(
                                        uiExtra.value, stocks) ??
                                    Galleries()));
                      },
                      child: Container(
                        height: 85.r,
                        width: 85.r,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: uiExtra.isSelected
                                    ? colors.textBlack
                                    : colors.icon),
                            borderRadius: BorderRadius.circular(8.r)),
                        child: CustomNetworkImage(
                          url: AppHelpers.checkIfImage(uiExtra.value, stocks)
                              ?.path,
                          fit: BoxFit.contain,
                          height: 85,
                          width: 85,
                          radius: 8,
                        ),
                      ),
                    ),
                  )
                : AppHelpers.checkIfHex(uiExtra.value)
                    ? Material(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Color(
                            int.parse('0xFF${uiExtra.value.substring(1, 7)}')),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.r),
                          onTap: () {
                            if (uiExtra.isSelected) {
                              return;
                            }
                            onUpdate(uiExtra);
                          },
                          child: uiExtra.isSelected
                              ? Container(
                                  width: 42.r,
                                  height: 42.r,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    FlutterRemix.check_double_line,
                                    color: uiExtra.value.substring(1, 7) ==
                                            "ffffff"
                                        ? CustomStyle.black
                                        : CustomStyle.white,
                                  ),
                                )
                              : SizedBox(width: 42.r, height: 42.r),
                        ),
                      )
                    : Material(
                        borderRadius: BorderRadius.circular(8.r),
                        color: CustomStyle.white,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.r),
                          onTap: () {
                            if (uiExtra.isSelected) {
                              return;
                            }
                            onUpdate(uiExtra);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                  color: uiExtra.isSelected
                                      ? CustomStyle.primary
                                      : CustomStyle.black.withOpacity(0.1),
                                  width: 1.5.r),
                            ),
                            padding: REdgeInsets.all(12),
                            child: Text(
                              uiExtra.value,
                              style: CustomStyle.interNormal(
                                size: 14,
                                color: CustomStyle.black,
                                letterSpacing: -14 * 0.01,
                              ),
                            ),
                          ),
                        ),
                      ),
          )
          .toList(),
    );
  }
}
