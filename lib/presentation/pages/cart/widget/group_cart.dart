import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/cart/cart_bloc.dart';
import 'package:goshops/infrastructure/model/response/cart_response.dart';
import 'package:goshops/infrastructure/model/response/product_calculate_response.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/pages/cart/widget/cart_item.dart';
import 'package:goshops/presentation/pages/cart/widget/coupon.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class GroupCartScreen extends StatelessWidget {
  final CustomColorSet colors;
  final List<UserCart>? cartCarts;
  final List<ProductNote>? notes;
  final List<ShopElement>? shopsProduct;

  const GroupCartScreen({
    super.key,
    required this.colors,
    required this.cartCarts,
    this.shopsProduct,
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.radiusMax.r),
          bottomRight: Radius.circular(AppConstants.radiusMax.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          32.verticalSpace,
          Row(
            children: [
              Text(
                AppHelpers.getTranslation(TrKeys.cart),
                style:
                CustomStyle.interNoSemi(color: colors.textBlack, size: 16),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    context
                        .read<CartBloc>()
                        .add(CartEvent.getCart(context: context));
                    if (LocalStorage.getToken().isNotEmpty) {
                      context.read<CartBloc>().add(
                          CartEvent.calculateCartWithCoupon(context: context));
                    }
                  },
                  icon: Icon(
                    FlutterRemix.refresh_line,
                    color: colors.textBlack,
                  ))
            ],
          ),
          16.verticalSpace,
          shopsProduct == null ? _cart() : _productCalculate(),
          32.verticalSpace,
        ],
      ),
    );
  }

  Widget _cart() {
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
              initiallyExpanded: cartUser?.userId == LocalStorage.getUser().id,
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      "${cartUser?.name ?? " "}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomStyle.interNormal(
                          color: colors.textBlack, size: 16),
                    ),
                  ),
                  if(cartUser?.userId != LocalStorage.getUser().id)
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (cartUser?.status ?? false)
                              ? CustomStyle.rate.withOpacity(.1)
                              : CustomStyle.success.withOpacity(.1)),
                      margin: const EdgeInsets.only(left: 10),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: (cartUser?.status ?? false)
                          ? Text(
                        AppHelpers.getTranslation(TrKeys.notReady),
                        style: const TextStyle(color: CustomStyle.rate),
                      )
                          : Text(
                        AppHelpers.getTranslation(TrKeys.ready),
                        style:
                        const TextStyle(color: CustomStyle.success),
                      ),
                    )
                ],
              ),
              children: [
                ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartUser?.cartDetails?.length ?? 0,
                    itemBuilder: (context, userIndex) {
                      final cartDetail = cartUser?.cartDetails?[userIndex];
                      return Theme(
                        data: Theme.of(context).copyWith(
                            dividerColor: CustomStyle.transparent,
                            primaryColor: colors.textBlack,
                            colorScheme: Theme.of(context).colorScheme.copyWith(
                                secondary: colors.textBlack,
                                primary: colors.textBlack)),
                        child: ExpansionTile(
                          initiallyExpanded: true,
                          tilePadding: EdgeInsets.zero,
                          title: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: colors.icon)),
                                child: CustomNetworkImage(
                                    url: cartDetail?.shop?.logoImg,
                                    height: 48,
                                    width: 48,
                                    radius: 24),
                              ),
                              16.horizontalSpace,
                              Text(
                                cartDetail?.shop?.translation?.title ?? "",
                                style: CustomStyle.interNormal(
                                    color: colors.textBlack),
                              )
                            ],
                          ),
                          children: [
                            ListView.builder(
                                padding: EdgeInsets.only(top: 16.r),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                cartDetail?.cartDetailProducts?.length ?? 0,
                                itemBuilder: (context, i) {
                                  return CartItem(
                                    isMine: cartUser?.userId ==
                                        LocalStorage.getUser().id,
                                    colors: colors,
                                    cartItem:
                                    cartDetail?.cartDetailProducts?[i],
                                    note: notes?.firstWhere(
                                            (e) =>
                                        e.stockId ==
                                            cartDetail?.cartDetailProducts?[i]
                                                .stocks?.id, orElse: () {
                                      return ProductNote();
                                    }).comment,
                                  );
                                }),
                            if (LocalStorage.getToken().isNotEmpty)
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: LocalStorage.getToken().isNotEmpty
                                          ? 24.r
                                          : 0),
                                  child: CouponWidget(
                                    colors: colors,
                                    shopId: cartDetail?.shop?.id ?? 0,
                                  )),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          );
        });
  }

  Widget _productCalculate() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: shopsProduct?.length ?? 0,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final stocks = shopsProduct?[index].stocks;
          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stocks?.length ?? 0,
              padding: EdgeInsets.zero,
              itemBuilder: (context, i) {
                return CartItem(
                  groupOrder: true,
                  colors: colors,
                  cartItem: CartDetailProduct(
                      quantity: stocks?[i].quantity,
                      price: stocks?[i].price,
                      discount: stocks?[i].discount,
                      stocks: stocks?[i].stock,
                      galleries: stocks?[i].stock?.product?.galleries),
                  note: "",
                );
              });
        });
  }
}
