import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/cart/cart_bloc.dart';
import 'package:goshops/application/product_detail/product_detail_bloc.dart';
import 'package:goshops/application/products/product_bloc.dart';
import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class BottomWidget extends StatelessWidget {
  final ProductData? product;
  final Stocks? selectStock;
  final CustomColorSet colors;

  const BottomWidget(
      {super.key,
      required this.colors,
      required this.product,
      required this.selectStock});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // _connectButton(colors, context),
          22.verticalSpace,
          if ((selectStock?.quantity ?? 0) > 0)
            AppHelpers.getCountCart(
                        productId: product?.id, stockId: selectStock?.id) !=
                    0
                ? _blurCart(context)
                : _buyAndCart(context),
          if (!((selectStock?.quantity ?? 0) > 0))
            const SizedBox(
              width: double.infinity,
            )
        ],
      ),
    );
  }

  Widget _blurCart(BuildContext context) {
    return BlurWrap(
      radius: BorderRadius.circular(AppConstants.radius.r),
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radius.r),
            color: colors.textBlack.withOpacity(0.3)),
        child: Row(
          children: [
            BlocBuilder<CartBloc, CartState>(
              buildWhen: (p, n) {
                return p.isLoading != n.isLoading;
              },
              builder: (context, state) {
                return ButtonEffectAnimation(
                  onTap: () {
                    if (state.isLoading) {
                      return;
                    }
                    context.read<CartBloc>().add(CartEvent.insertCart(
                          context: context,
                          onSuccess: () {
                            context
                                .read<ProductBloc>()
                                .add(const ProductEvent.updateState());
                          AppRoute.goCartPage(context);
                          },
                        ));
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.r, horizontal: 24.r),
                    decoration: BoxDecoration(
                      color: CustomStyle.black,
                      borderRadius: BorderRadius.circular(AppConstants.radius.r),
                    ),
                    child: state.isLoading
                        ? const Loading(changeColor: true)
                        : Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/selectBag.svg",
                                height: 14.r,
                              ),
                              8.horizontalSpace,
                              Text(
                                AppHelpers.getTranslation(TrKeys.goToCart),
                                style: CustomStyle.interNormal(
                                    color: CustomStyle.white, size: 16),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
            const Spacer(),
            ButtonEffectAnimation(
              onTap: () {
                AppHelpers.removeProduct(
                    context: context, product: product, stock: selectStock);
                context
                    .read<ProductDetailBloc>()
                    .add(const ProductDetailEvent.updateState());
              },
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary,
                ),
                child: Icon(
                  FlutterRemix.subtract_line,
                  color: colors.white,
                ),
              ),
            ),
            12.horizontalSpace,
            Text(
              (AppHelpers.getCountCart(
                          productId: product?.id, stockId: selectStock?.id) *
                      (product?.interval ?? 1))
                  .toString(),
              style: CustomStyle.interNormal(color: colors.white, size: 20),
            ),
            12.horizontalSpace,
            ButtonEffectAnimation(
              onTap: () {
                AppHelpers.addProduct(
                    context: context, product: product, stock: selectStock);
                context
                    .read<ProductDetailBloc>()
                    .add(const ProductDetailEvent.updateState());
              },
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary,
                ),
                child: Icon(
                  FlutterRemix.add_line,
                  color: colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buyAndCart(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BlocBuilder<CartBloc, CartState>(
            buildWhen: (p, n) {
              return p.isLoading != n.isLoading;
            },
            builder: (context, state) {
              return CustomButton(
                title: AppHelpers.getTranslation(TrKeys.buyNow),
                isLoading: state.isLoading,
                bgColor: colors.primary,
                titleColor: colors.white,
                onTap: () {
                  AppHelpers.addProduct(
                      context: context, product: product, stock: selectStock);
                  context.read<CartBloc>().add(CartEvent.insertCart(
                        context: context,
                        onSuccess: () {
                          context
                              .read<ProductBloc>()
                              .add(const ProductEvent.updateState());
                          AppRoute.goCartPage(context);
                        },
                      ));
                },
              );
            },
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: CustomButton(
            title: AppHelpers.getTranslation(TrKeys.addToCart),
            bgColor: colors.bottomBarColor,
            titleColor: colors.white,
            onTap: () {
              AppHelpers.addProduct(
                  context: context, product: product, stock: selectStock);
              context
                  .read<ProductDetailBloc>()
                  .add(const ProductDetailEvent.updateState());
            },
          ),
        )
      ],
    );
  }

}
