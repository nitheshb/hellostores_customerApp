import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/order/order_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/keyboard_dismisser.dart';
import 'package:goshops/presentation/pages/checkout/widget/checkout_product_item.dart';
import 'package:goshops/presentation/pages/order/widgets/order_status.dart';
import 'package:goshops/presentation/pages/order/widgets/price_info.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

import 'widgets/order_title.dart';

class RefundScreen extends StatelessWidget {
  final CustomColorSet colors;
  final ScrollController controller;

  const RefundScreen({
    super.key,
    required this.colors,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      isLtr: LocalStorage.getLangLtr(),
      child: Container(
        margin: MediaQuery.viewInsetsOf(context),
        width: double.infinity,
        decoration: BoxDecoration(
          color: colors.newBoxColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppConstants.radiusMax.r),
            topLeft: Radius.circular(AppConstants.radiusMax.r),
          ),
        ),
        padding: EdgeInsets.only(
          left: 16.r,
          right: 16.r,
        ),
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            String? ids;
            state.order?.orderShops?.forEach((element) {
              ids = (ids ?? "") +
                  ((ids?.isNotEmpty ?? false) ? "-" : "") +
                  element.id.toString();
            });
            return ListView(
              controller: controller,
              padding: EdgeInsets.symmetric(vertical: 24.r),
              children: [
                OrderTitle(
                  order: state.refundOrder?.order,
                  colors: colors,
                  id: ids,
                ),
                10.verticalSpace,
                OrderStatusWidget(
                  colors: colors,
                  status: state.refundOrder?.order?.status,
                  createAt: state.refundOrder?.order?.createdAt,
                  notes: state.refundOrder?.order?.notes,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.refundOrder?.order?.details?.length ?? 0,
                    padding: EdgeInsets.only(top: 24.r),
                    itemBuilder: (context, index) {
                      final cartDetailProduct =
                          state.refundOrder?.order?.details?[index];
                      return CheckoutProductItem(
                        colors: colors,
                        cartItem: cartDetailProduct,
                      );
                    }),
                Text(
                  "${AppHelpers.getTranslation(TrKeys.refund)} ${AppHelpers.getTranslation(TrKeys.status)} : ${state.refundOrder?.status ?? ""}",
                  style: CustomStyle.interRegular(
                      color: colors.textBlack, size: 18),
                ),
                8.verticalSpace,
                Text(
                  "${AppHelpers.getTranslation(TrKeys.refund)} ${AppHelpers.getTranslation(TrKeys.reason)} : ${state.refundOrder?.cause ?? ""}",
                  style: CustomStyle.interRegular(
                      color: colors.textBlack, size: 18),
                ),
                if (state.refundOrder?.answer != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8.r),
                    child: Text(
                      "${AppHelpers.getTranslation(TrKeys.refund)} ${AppHelpers.getTranslation(TrKeys.answer)} : ${state.refundOrder?.answer ?? ""}",
                      style: CustomStyle.interRegular(
                          color: colors.textBlack, size: 18),
                    ),
                  ),
                24.verticalSpace,
                PriceInfo(colors: colors, order: state.refundOrder?.order),
              ],
            );
          },
        ),
      ),
    );
  }
}
