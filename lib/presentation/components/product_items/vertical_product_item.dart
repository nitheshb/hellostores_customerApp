import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/products/product_bloc.dart';
import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme_wrapper.dart';

class VerticalProductItem extends StatelessWidget {
  final ProductData product;
  final VoidCallback? addAndRemove;

  const VerticalProductItem(
      {super.key, required this.product, this.addAndRemove})
     ;

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(builder: (colors, controller) {
      return Padding(
        padding: EdgeInsets.only(bottom: 24.r),
        child: InkWell(
          onTap: () {
            AppRoute.goProductPage(context: context, product: product);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMax.r),
                  border: Border.all(color: CustomStyle.icon),
                  color: CustomStyle.shimmerBase,
                ),
                child: Stack(
                  children: [
                    CustomNetworkImage(
                      url: product.img,
                      height: 168,
                      width: 168,
                      radius: AppConstants.radiusMax,
                    ),
                    SizedBox(
                      width: 168.r,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              16.horizontalSpace,
                              if (product.stocks?.isNotEmpty ?? false)
                                if (product.stocks?.first.discount != null)
                                  SvgPicture.asset("assets/svg/discount.svg"),
                              const Spacer(),
                              IconButton(
                                  splashColor: CustomStyle.transparent,
                                  highlightColor: CustomStyle.transparent,
                                  onPressed: () {
                                    LocalStorage.setLikedProductsList(
                                        product.id ?? 0);
                                    context
                                        .read<ProductBloc>()
                                        .add(const ProductEvent.updateState());
                                    addAndRemove?.call();
                                  },
                                  icon: LocalStorage.getLikedProductsList()
                                          .contains(product.id)
                                      ? Icon(
                                          FlutterRemix.heart_3_fill,
                                          color: CustomStyle.red,
                                          size: 24.r,
                                        )
                                      : Icon(
                                          FlutterRemix.heart_3_line,
                                          size: 24.r,
                                        ))
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              8.horizontalSpace,
              SizedBox(
                width: MediaQuery.sizeOf(context).width - 216.r,
                height: 170.r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.translation?.title ?? "",
                      style: CustomStyle.interNormal(
                          color: colors.textBlack, size: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    8.verticalSpace,
                    if ((product.ratingAvg ?? 0) == 0)
                      Text(
                        AppHelpers.getTranslation(TrKeys.newKey),
                        style: CustomStyle.interNoSemi(color: colors.textHint, size: 12),
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset("assets/svg/start.svg"),
                          4.horizontalSpace,
                          Text(
                            product.ratingAvg?.toStringAsPrecision(2) ?? "0.0",
                            style: CustomStyle.interNoSemi(
                                color: colors.textHint, size: 12),
                          ),
                          4.horizontalSpace,
                          Text(
                            '(${product.ratingCount} ${AppHelpers.getTranslation(TrKeys.reviews).toLowerCase()})',
                            style: CustomStyle.interNoSemi(
                              size: 12,
                              color: colors.textHint,
                              letterSpacing: -0.35,
                            ),
                          )
                        ],
                      ),
                    const Spacer(),
                    if (product.stocks?.isNotEmpty ?? false)
                      AppHelpers.numberFormat(
                                       product.stocks?.first.price ?? 0)
                                  .length <
                              9
                          ? Row(
                              children: [
                                Text(
                                  AppHelpers.numberFormat(
                                      
                                          product.stocks?.first.totalPrice ??
                                              0),
                                  style: CustomStyle.interSemi(
                                      color: colors.textBlack, size: 20),
                                ),
                                if (product.stocks?.first.discount != null)
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.r),
                                    child: Text(
                                      AppHelpers.numberFormat(
                                          
                                              product.stocks?.first.price ?? 0),
                                      style: CustomStyle.interSemi(
                                          color: CustomStyle.red,
                                          size: 14,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                  ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppHelpers.numberFormat(
                                      
                                          product.stocks?.first.totalPrice ??
                                              0),
                                  style: CustomStyle.interSemi(
                                      color: colors.textBlack, size: 20),
                                ),
                                if (product.stocks?.first.discount != null)
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.r),
                                    child: Text(
                                      AppHelpers.numberFormat(
                                          
                                              product.stocks?.first.price ?? 0),
                                      style: CustomStyle.interSemi(
                                          color: CustomStyle.red,
                                          size: 14,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                  ),
                              ],
                            ),
                    12.verticalSpace,
                    if (product.stocks?.isNotEmpty ?? false)
                      !AppHelpers.productInclude(
                              productId: product.id,
                              stockId: product.stocks?.first.id)
                          ? SecondButton(
                              title:
                                  AppHelpers.getTranslation(TrKeys.addToCart),
                              bgColor: colors.categoryColor,
                              titleColor: CustomStyle.white,
                              titleSize: 16,
                              onTap: () {
                                AppHelpers.addProduct(
                                    context: context,
                                    product: product,
                                    stock: product.stocks?.first);
                                addAndRemove?.call();
                              })
                          : Container(
                              decoration: BoxDecoration(
                                color: colors.categoryColor,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radius.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(4.r),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ButtonEffectAnimation(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: CustomStyle.socialButtonLight,
                                          borderRadius: BorderRadius.circular(
                                              AppConstants.radius.r),
                                        ),
                                        child: IconButton(
                                          splashColor: CustomStyle.transparent,
                                          highlightColor:
                                              CustomStyle.transparent,
                                          onPressed: () {
                                            AppHelpers.removeProduct(
                                                context: context,
                                                product: product,
                                                stock: product.stocks?.first);
                                            addAndRemove?.call();
                                          },
                                          icon: Icon(
                                            AppHelpers.getCountCart(
                                                        productId: product.id,
                                                        stockId: product.stocks
                                                            ?.first.id) ==
                                                    1
                                                ? FlutterRemix.delete_bin_2_line
                                                : FlutterRemix.subtract_line,
                                            color: colors.white,
                                            size: AppHelpers.getCountCart(
                                                        productId: product.id,
                                                        stockId: product.stocks
                                                            ?.first.id) ==
                                                    1
                                                ? 20.r
                                                : 22.r,
                                          ),
                                        ),
                                      ),
                                    ),
                                    12.horizontalSpace,
                                    Text(
                                      (AppHelpers.getCountCart(
                                                  productId: product.id,
                                                  stockId: product
                                                      .stocks?.first.id) *
                                              (product.interval ?? 1))
                                          .toString(),
                                      style: CustomStyle.interNormal(
                                          color: CustomStyle.white, size: 16),
                                    ),
                                    12.horizontalSpace,
                                    ButtonEffectAnimation(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                CustomStyle.socialButtonLight,
                                            borderRadius: BorderRadius.circular(
                                                AppConstants.radius.r)),
                                        child: IconButton(
                                          splashColor: CustomStyle.transparent,
                                          padding: EdgeInsets.zero,
                                          splashRadius: 12,
                                          highlightColor:
                                              CustomStyle.transparent,
                                          onPressed: () {
                                            AppHelpers.addProduct(
                                                context: context,
                                                product: product,
                                                stock: product.stocks?.first);
                                            addAndRemove?.call();
                                          },
                                          icon: Icon(
                                            FlutterRemix.add_line,
                                            color: colors.white,
                                            size: 22.r,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
