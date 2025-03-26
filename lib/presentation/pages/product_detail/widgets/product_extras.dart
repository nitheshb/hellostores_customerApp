import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goshops/application/product_detail/product_detail_bloc.dart';
import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/infrastructure/model/model/review_data.dart';
import 'package:goshops/infrastructure/model/model/typed_extra.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/app_assets.dart';
import 'package:goshops/presentation/components/extras/color_extras.dart';
import 'package:goshops/presentation/components/extras/image_extras.dart';
import 'package:goshops/presentation/components/extras/text_extras.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'package:provider/provider.dart';

import 'product_price_widget.dart';

class ProductExtras extends StatelessWidget {
  final List<TypedExtra> types;
  final List<Stocks> stocks;
  final Stocks? selectStock;
  final ProductData? product;
  final List<Galleries> list;
  final CustomColorSet colors;

  const ProductExtras({
    super.key,
    required this.types,
    required this.colors,
    required this.stocks,
    required this.list,
    required this.selectStock,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: REdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colors.newBoxColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: REdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          18.verticalSpace,
          ProductPriceWidget(
            selectedStock: selectStock,
            colors: colors,
          ),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    FlutterRemix.star_smile_fill,
                    color: CustomStyle.rate,
                    size: 20.r,
                  ),
                  6.horizontalSpace,
                  Text(
                    (product?.ratingAvg ?? 0).toStringAsFixed(1),
                    style: CustomStyle.interNormal(
                      size: 14,
                      color: colors.textBlack,
                      letterSpacing: -0.35,
                    ),
                  ),
                  4.horizontalSpace,
                  Text(
                    '(${product?.ratingCount ?? 0} ${AppHelpers.getTranslation(TrKeys.reviews).toLowerCase()})',
                    style: CustomStyle.interNormal(
                      size: 14,
                      color: colors.textBlack,
                      letterSpacing: -0.35,
                    ),
                  )
                ],
              ),
            ],
          ),
          16.verticalSpace,
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: types.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final TypedExtra typedExtra = types[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: colors.backgroundColor,
                ),
                padding: REdgeInsets.symmetric(horizontal: 12, vertical: 14),
                margin: REdgeInsets.only(bottom: 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${typedExtra.title} : ${AppHelpers.getNameColor(typedExtra.uiExtras.firstWhere(
                            (element) => element.isSelected == true,
                            orElse: () => UiExtra("", false, index),
                          ).value)}",
                      style: CustomStyle.interNoSemi(
                        size: 16,
                        color: colors.textBlack,
                        letterSpacing: -0.35,
                      ),
                    ),
                    16.verticalSpace,
                    typedExtra.type == ExtrasType.text
                        ? TextExtras(
                            list: list,
                            selectStock: selectStock,
                            uiExtras: typedExtra.uiExtras,
                            groupIndex: typedExtra.groupIndex,
                            onUpdate: (uiExtra) {
                              context.read<ProductDetailBloc>().add(
                                  ProductDetailEvent.updateSelectedIndexes(
                                      typedExtra.groupIndex,
                                      uiExtra.index,
                                      context));
                            },
                          )
                        : typedExtra.type == ExtrasType.color
                            ? ColorExtras(
                                stocks: stocks,
                                selectStock: selectStock,
                                uiExtras: typedExtra.uiExtras,
                                groupIndex: typedExtra.groupIndex,
                                onUpdate: (uiExtra) {
                                  context.read<ProductDetailBloc>().add(
                                        ProductDetailEvent
                                            .updateSelectedIndexes(
                                          typedExtra.groupIndex,
                                          uiExtra.index,
                                          context,
                                        ),
                                      );
                                },
                              )
                            : typedExtra.type == ExtrasType.image
                                ? ImageExtras(
                                    selectStock: selectStock,
                                    uiExtras: typedExtra.uiExtras,
                                    groupIndex: typedExtra.groupIndex,
                                    updateImage: (s) {},
                                    onUpdate: (uiExtra) {
                                      context.read<ProductDetailBloc>().add(
                                            ProductDetailEvent
                                                .updateSelectedIndexes(
                                              typedExtra.groupIndex,
                                              uiExtra.index,
                                              context,
                                            ),
                                          );
                                    },
                                  )
                                : const SizedBox.shrink(),
                  ],
                ),
              );
            },
          ),
          10.verticalSpace,
          Row(
            children: [
              SvgPicture.asset(
                Assets.svgIcCertificateCheck,
                colorFilter: ColorFilter.mode(
                  colors.textBlack,
                  BlendMode.srcIn,
                ),
                width: 18.r,
                height: 18.r,
              ),
              7.horizontalSpace,
              Text(
                (selectStock?.quantity != null &&
                        ((selectStock?.quantity)! > 0))
                    ? '${selectStock?.quantity} ${AppHelpers.getTranslation(TrKeys.inStock).toLowerCase()}'
                    : AppHelpers.getTranslation(TrKeys.outOfStock),
                style: CustomStyle.interNormal(
                  size: 14,
                  color: colors.textBlack,
                  letterSpacing: -0.35,
                ),
              ),
            ],
          ),
          22.verticalSpace,
        ],
      ),
    );
  }
}
