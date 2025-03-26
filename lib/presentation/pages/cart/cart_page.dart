import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/cart/cart_bloc.dart';
import 'package:goshops/infrastructure/model/response/cart_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/pages/cart/widget/group_cart.dart';
import 'package:goshops/presentation/pages/cart/widget/my_cart_screen.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

import 'widget/cheque.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: (colors) => CustomAppBar(
        colors: colors,
        context: context,
        title: TrKeys.orderDetail,
      ),
      body: (colors) => SafeArea(
        bottom: false,
        child: BlocConsumer<CartBloc, CartState>(
          listenWhen: (p, n) {
            return p.coupons != n.coupons && n.coupons.isNotEmpty;
          },
          listener: (BuildContext context, CartState state) {
            context
                .read<CartBloc>()
                .add(CartEvent.calculateCartWithCoupon(context: context));
          },
          builder: (context, state) {
            bool check = false;
            for (UserCart cart in state.cart?.userCarts ?? []) {
              if (cart.status ?? true) {
                check = true;
                break;
              }
            }
            bool fullDigital = true;
            state.cart?.userCarts?.forEach((user) {
              user.cartDetails?.forEach((cartDetails) {
                cartDetails.cartDetailProducts?.forEach((product) {
                  if (!(product.stocks?.product?.digital ?? false)) {
                    fullDigital = false;
                    return;
                  }
                });
              });
            });
            return Stack(
              children: [
                Container(
                  color: colors.newBoxColor,
                  child: ListView(
                    padding: EdgeInsets.only(bottom: 120.r),
                    children: [
                      LocalStorage.getCartList()
                                  .where((element) => element.count > 0)
                                  .isEmpty &&
                              !(state.cart?.group ?? false)
                          ? _emptyScreen(colors)
                          : Column(
                              children: [
                                (state.cart?.group ?? false)
                                    ? GroupCartScreen(
                                        colors: colors,
                                        notes: state.notes,
                                        cartCarts: state.cart?.userCarts)
                                    : MyCartScreen(
                                        colors: colors,
                                        cartDetails: (state
                                                    .cart
                                                    ?.userCarts
                                                    ?.isNotEmpty ??
                                                false)
                                            ? state.cart?.userCarts?.first
                                                .cartDetails
                                            : null,
                                        notes: state.notes,
                                        shopsProduct: state
                                            .productCalculate
                                            ?.data
                                            ?.shops,
                                      ),
                                ChequeWidget(
                                  group: check &&
                                      (state.cart?.group ?? false),
                                  ready: !(state.cart?.userCarts
                                          ?.firstWhere(
                                              (element) =>
                                                  element.uuid ==
                                                  LocalStorage
                                                          .getGroupOrder()
                                                      .uuid,
                                              orElse: () => UserCart())
                                          .status ??
                                      false),
                                  colors: colors,
                                  cart: state.cartCalculate,
                                  productCalculate:
                                      state.productCalculate?.data,
                                  fullDigital: fullDigital,
                                )
                              ],
                            )
                    ],
                  ),
                ),
                if (state.isLoading || state.isButtonLoading)
                  _customLoading(context, colors)
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _customLoading(BuildContext context, CustomColorSet colors) {
    return BlurWrap(
      radius: BorderRadius.zero,
      blur: 1,
      child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          color: colors.backgroundColor.withOpacity(0.2),
          child: const Loading()),
    );
  }

  Column _emptyScreen(CustomColorSet colors) {
    return Column(
      children: [
        124.verticalSpace,
        Image.asset("assets/images/emptyCart.png"),
        24.verticalSpace,
        Text(
          AppHelpers.getTranslation(TrKeys.yourCartIsEmpty),
          style: CustomStyle.interNormal(color: colors.textBlack, size: 14),
        )
      ],
    );
  }
}
