import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/cart/cart_bloc.dart';
import 'package:goshops/application/checkout/checkout_bloc.dart';
import 'package:goshops/application/main/main_bloc.dart';
import 'package:goshops/application/order/order_bloc.dart';
import 'package:goshops/application/products/product_bloc.dart';
import 'package:goshops/infrastructure/model/request/create_order_model.dart';
import 'package:goshops/infrastructure/model/response/payments_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';

import 'package:goshops/presentation/style/theme/theme.dart';
import 'widget/current_order_status_widget.dart';
import 'payment_screen.dart';
import 'shipping_screen.dart';
import 'verify_screen.dart';

class CheckoutPage extends StatefulWidget {
  final bool fullDigital;

  const CheckoutPage({super.key, required this.fullDigital});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  Map<int, TextEditingController> comments = {};
  bool checkDigital = true;

  List<Tab> listTabs = [
    Tab(
      child: Text(AppHelpers.getTranslation(TrKeys.delivered)),
    ),
    Tab(
      child: Text(AppHelpers.getTranslation(TrKeys.pickup)),
    ),
  ];

  @override
  void initState() {
    if (widget.fullDigital) {
      context
          .read<CheckoutBloc>()
          .add(CheckoutEvent.changeStep(context: context, step: 2));
    }
    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (tabController.index == 1) {
          context
              .read<CheckoutBloc>()
              .add(const CheckoutEvent.changeActive(active: true));
        } else {
          context
              .read<CheckoutBloc>()
              .add(const CheckoutEvent.changeActive(active: false));
        }
      });
    context
        .read<CartBloc>()
        .state
        .cart
        ?.userCarts
        ?.first
        .cartDetails
        ?.forEach((element) {
      comments.addAll({element.shop?.id ?? 0: TextEditingController()});
    });

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  createOrder(CheckoutState state, CartState cartState, CreateOrderModel order,
      {String? url}) {
    context.read<OrderBloc>().add(
          OrderEvent.createOrder(
            totalPrice: context.read<CartBloc>().state.cart?.totalPrice ?? 0,
            context: context,
            order: order,
            onSuccess: () {
              LocalStorage.deleteCartList();
              context.read<MainBloc>().add(const MainEvent.changeIndex(index: 0));
              context.read<CartBloc>().add(CartEvent.checkCoupon(
                  context: context, coupon: "", shopId: 0, clear: true));
              AppRoute.goCongratsPage(context);
              context.read<ProductBloc>().add(const ProductEvent.updateState());
              return;
            },
            onFailure: () {
              AppRoute.goFailOrderPage(context);
            },
            payment: state.list?.firstWhere(
                    (element) => element.id == state.selectId, orElse: () {
                  return PaymentData();
                }) ??
                PaymentData(),
            link: url,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: (colors) => BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          return Column(
            children: [
              _appBar(context, colors, state),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    if (state.step == 1)
                      ShippingScreen(
                        markers: state.markers,
                        isLoadingPoint: state.isLoadingPoint,
                        colors: colors,
                        tabController: tabController,
                        list: listTabs,
                        listPoints: state.deliveryPoints ?? [],
                        selectPointId: state.selectPointId,
                        listAddress: state.address,
                        isLoading: state.isLoading,
                        selectAddress: state.selectAddress,
                      ),
                    if (state.step == 2)
                      PaymentMethodsScreen(
                        colors: colors,
                        list: state.list ?? [],
                        selectId: state.selectId,
                      ),
                    if (state.step == 3)
                      VerifyScreen(
                        controllers: comments,
                        colors: colors,
                        dateTime: state.deliveryDate,
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingButton: (colors) => _bottom(colors, context),
    );
  }

  Widget _bottom(CustomColorSet colors, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.r),
          child: BlocBuilder<CheckoutBloc, CheckoutState>(
            buildWhen: (p, n) {
              return p.step != n.step ||
                  p.isActive != n.isActive ||
                  p.isLoading != n.isLoading ||
                  p.isLoadingPoint != n.isLoadingPoint ||
                  p.selectId != n.selectId ||
                  p.deliveryDate != n.deliveryDate ||
                  p.deliveryPrice?.length != n.deliveryPrice?.length;
            },
            builder: (context, state) {
              return Row(
                children: [
                  Expanded(
                    child: ButtonEffectAnimation(
                      onTap: () {
                        if (widget.fullDigital && state.step == 2) {
                          Navigator.pop(context);
                          return;
                        }
                        if (state.step == 1) {
                          Navigator.pop(context);
                          return;
                        }
                        context.read<CheckoutBloc>().add(CheckoutEvent.changeStep(
                            context: context, step: state.step - 1));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.bottomBarColor),
                          color: colors.newBoxColor,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radius.r,
                          ),
                        ),
                        child: Icon(
                          FlutterRemix.arrow_left_s_line,
                          color: colors.textBlack,
                          size: 22.r,
                        ),
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    flex: 4,
                    child: BlocBuilder<OrderBloc, OrderState>(
                      builder: (context, stateOrder) {
                        bool active = checkDigital
                            ? true
                            : state.isActive
                                ? (state.deliveryPoints?.isNotEmpty ?? false)
                                : ((state.deliveryPrice?.isNotEmpty ?? false) &&
                                    (state.address.isNotEmpty));
                        return BlocBuilder<CartBloc, CartState>(
                          builder: (context, cartState) {
                            if (state.step == 3 && AppConstants.isAcceptTerm) {
                              active = cartState.isAcceptTerm;
                            }
                            return CustomButton(
                                isLoading: stateOrder.isLoading,
                                title: AppHelpers.getTranslation(state.step == 3
                                    ? TrKeys.confirmAndPay
                                    : TrKeys.next),
                                bgColor:
                                    !active ? colors.newBoxColor : colors.primary,
                                titleColor:
                                    !active ? colors.textBlack : colors.white,
                                onTap: () {
                                  if (active) {
                                    checkDigital = true;
                                    if (state.step == 2) {
                                      cartState.cart?.userCarts
                                          ?.forEach((userCart) {
                                        userCart.cartDetails?.forEach((detail) {
                                          detail.cartDetailProducts
                                              ?.forEach((element) {
                                            if (element
                                                    .stocks?.product?.digital ??
                                                false) {
                                              if (state.list?.firstWhere(
                                                      (payment) =>
                                                          payment.id ==
                                                          state.selectId,
                                                      orElse: () {
                                                    return PaymentData();
                                                  }).tag ==
                                                  "cash") {
                                                AppHelpers.openDialog(
                                                    context: context,
                                                    title: AppHelpers
                                                        .getTranslation(TrKeys
                                                            .youCannotPayWithCashBecauseThereTheCart));
                                                checkDigital = false;
                                                return;
                                              }
                                            }
                                          });
                                        });
                                      });
                                      context.read<CartBloc>().add(
                                          CartEvent.calculateCart(
                                              fullDigital: widget.fullDigital,
                                              context: context,
                                              deliveryPriceId: (state
                                                          .deliveryPrice
                                                          ?.isNotEmpty ??
                                                      false)
                                                  ? state.deliveryPrice?.first.id
                                                  : null,
                                              pointId: state.selectPointId,
                                              type: tabController.index));
                                    }
                                    if (state.step == 3) {
                                      final payments = state.list?.where(
                                          (element) =>
                                              element.id == state.selectId);
                                      final tag = payments!.isNotEmpty
                                          ? payments.first.tag
                                          : '';
                                      final order = CreateOrderModel(
                                        paymentId: (state.list?.firstWhere(
                                                        (element) =>
                                                            element.id ==
                                                            state.selectId,
                                                        orElse: () {
                                                      return PaymentData();
                                                    }) ??
                                                    PaymentData())
                                                .id ??
                                            0,
                                        note: comments,
                                        coupons: cartState.coupons,
                                        notes:
                                            context.read<CartBloc>().state.notes,
                                        cartId: context
                                                .read<CartBloc>()
                                                .state
                                                .cart
                                                ?.id ??
                                            0,
                                        pointId: state.selectPointId,
                                        deliveryType: widget.fullDigital
                                            ? DeliveryTypeEnum.digital
                                            : tabController.index == 0
                                                ? DeliveryTypeEnum.delivery
                                                : DeliveryTypeEnum.pickup,
                                        addressId: state.address.isNotEmpty
                                            ? state
                                                .address[state.selectAddress].id
                                            : null,
                                        deliveryDate: state.deliveryDate,
                                        deliveryPriceId: (state
                                                    .deliveryPrice?.isNotEmpty ??
                                                false)
                                            ? (state.deliveryPrice?.first.id ?? 0)
                                            : 0,
                                      );
                                      if (tag == 'maksekeskus') {
                                        AppRoute.goMaksekeskusBottomSheet(
                                            context: context,
                                            colors: colors,
                                            order: order,
                                            onSuccess: (url) {
                                              createOrder(state, cartState, order,
                                                  url: url);
                                            });
                                      } else {
                                        createOrder(state, cartState, order);
                                      }
                                    }

                                    if (checkDigital) {
                                      context.read<CheckoutBloc>().add(
                                          CheckoutEvent.changeStep(
                                              context: context));
                                    }
                                  }
                                });
                          },
                        );
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _appBar(
    BuildContext context,
    CustomColorSet colors,
    CheckoutState state,
  ) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.newBoxColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.radius.r),
          bottomRight: Radius.circular(AppConstants.radius.r),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                AppHelpers.getTranslation(TrKeys.checkout),
                style: CustomStyle.interSemi(color: colors.textBlack, size: 22),
              ),
            ),
            Container(
              height: 100.r,
              padding: REdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              child: Row(
                children: [
                  CurrentOrderStatusWidget(
                    title: AppHelpers.getTranslation(TrKeys.shipping),
                    isDone: state.step > 1,
                    isActive: state.step == 1,
                    iconData: FlutterRemix.map_2_line,
                    colors: colors,
                  ),
                  9.horizontalSpace,
                  CurrentOrderStatusWidget(
                    title: AppHelpers.getTranslation(TrKeys.payment),
                    isDone: state.step > 2,
                    isActive: state.step == 2,
                    iconData: FlutterRemix.bank_card_line,
                    colors: colors,
                  ),
                  9.horizontalSpace,
                  CurrentOrderStatusWidget(
                    title: AppHelpers.getTranslation(TrKeys.verify),
                    isDone: false,
                    isActive: state.step == 3,
                    iconData: FlutterRemix.check_double_line,
                    colors: colors,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
