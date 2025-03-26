import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/cart/cart_bloc.dart';
import 'package:goshops/infrastructure/model/response/cart_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/pages/checkout/widget/checkout_product_item.dart';
import 'package:goshops/presentation/pages/checkout/widget/verify_prices.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class VerifyScreen extends StatelessWidget {
  final CustomColorSet colors;
  final DateTime? dateTime;
  final Map<int, TextEditingController> controllers;

  const VerifyScreen(
      {super.key,
      required this.colors,
      required this.dateTime,
      required this.controllers});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(
        top: 20.r,
        left: 16.r,
        right: 16.r,
        bottom: 100.r,
      ),
      children: [
        Text(
          AppHelpers.getTranslation(TrKeys.yourOrder),
          style: CustomStyle.interSemi(color: colors.textBlack, size: 16),
        ),
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final cartDetails = state.cart?.userCarts?.first.cartDetails;
            final cartCalculate = state.cartCalculate;
            return Column(
              children: [
                state.cart?.group ?? false
                    ? _group(state.cart?.userCarts)
                    : _simple(cartDetails),
                24.verticalSpace,
                state.isLoading
                    ? const Loading()
                    : VerifyPrices(
                        colors: colors,
                        cart: cartCalculate,
                      ),
                if (AppConstants.isAcceptTerm)
                  Row(
                    children: [
                      Checkbox(
                        value: state.isAcceptTerm,
                        onChanged: (v) {
                          context
                              .read<CartBloc>()
                              .add(const CartEvent.acceptTerm());
                        },
                        fillColor: WidgetStateProperty.all(
                          state.isAcceptTerm
                              ? colors.primary
                              : colors.transparent,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        side: BorderSide(color: colors.primary),
                      ),
                      Text(
                        AppHelpers.getTranslation(TrKeys.iAccept),
                        style: CustomStyle.interBold(
                            color: colors.textBlack, size: 14),
                      ),
                      InkWell(
                        onTap: () =>
                            AppRoute.goTerm(context: context, isProfile: false),
                        child: Padding(
                          padding: REdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            AppHelpers.getTranslation(TrKeys.terms).toLowerCase(),
                            style: CustomStyle.interBold(
                                color: colors.primary, size: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _group(List<UserCart>? cartCarts) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cartCarts?.length ?? 0,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final cartUser = cartCarts?[index];
          return Theme(
            data: Theme.of(context).copyWith(
                dividerColor: CustomStyle.transparent,
                primaryColor: colors.textBlack,
                unselectedWidgetColor: colors.textBlack,
                colorScheme: Theme.of(context).colorScheme.copyWith(
                    secondary: colors.textBlack, primary: colors.textBlack)),
            child: ExpansionTile(
              title: Text(
                cartUser?.name ?? "",
                style:
                    CustomStyle.interNormal(color: colors.textBlack, size: 16),
              ),
              children: [
                ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartUser?.cartDetails?.length ?? 0,
                    itemBuilder: (context, i) {
                      final cartDetail = cartUser?.cartDetails?[i];
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              cartDetail?.cartDetailProducts?.length ?? 0,
                          itemBuilder: (context, productIndex) {
                            final cartDetailProduct =
                                cartDetail?.cartDetailProducts?[productIndex];
                            return CheckoutProductItem(
                              colors: colors,
                              cartItem: cartDetailProduct,
                            );
                          });
                    })
              ],
            ),
          );
        });
  }

  Widget _simple(List<CartDetail>? cartDetails) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cartDetails?.length ?? 0,
        padding: EdgeInsets.only(top: 24.r),
        itemBuilder: (context, index) {
          final cartDetailProduct = cartDetails?[index].cartDetailProducts;
          return AppHelpers.getCartUiType() == 1
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartDetailProduct?.length ?? 0,
                  itemBuilder: (context, i) {
                    return CheckoutProductItem(
                      colors: colors,
                      cartItem: cartDetailProduct?[i],
                    );
                  })
              : Theme(
                  data: Theme.of(context).copyWith(
                      dividerColor: CustomStyle.transparent,
                      primaryColor: colors.textBlack,
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                          secondary: colors.textBlack,
                          primary: colors.textBlack)),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: colors.icon)),
                          child: CustomNetworkImage(
                              url: cartDetails?[index].shop?.logoImg,
                              height: 48,
                              width: 48,
                              radius: 24),
                        ),
                        16.horizontalSpace,
                        Flexible(
                          child: Text(
                            cartDetails?[index].shop?.translation?.title ?? "",
                            style:
                                CustomStyle.interNormal(color: colors.textBlack),
                          ),
                        ),
                        8.horizontalSpace,
                        if (cartDetails?[index].shop?.deliveryTime != null)
                          Text(
                            "(${AppHelpers.getTranslation(TrKeys.est)} ${cartDetails?[index].shop?.deliveryTime?.from} - ${cartDetails?[index].shop?.deliveryTime?.to} ${AppHelpers.getTranslation(cartDetails?[index].shop?.deliveryTime?.type ?? "")})",
                            style: CustomStyle.interNormal(
                                color: colors.textHint, size: 14),
                          ),
                      ],
                    ),
                    children: [
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartDetailProduct?.length ?? 0,
                          itemBuilder: (context, i) {
                            return CheckoutProductItem(
                              colors: colors,
                              cartItem: cartDetailProduct?[i],
                            );
                          }),
                      CustomTextFormField(
                        hint: AppHelpers.getTranslation(TrKeys.orderComment),
                        controller: controllers.values.elementAt(index),
                        prefixIcon: Icon(
                          FlutterRemix.chat_1_fill,
                          color: colors.textBlack,
                        ),
                      ),
                      16.verticalSpace,
                    ],
                  ),
                );
        });
  }
}
