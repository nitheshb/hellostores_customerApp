import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/cart/cart_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'package:goshops/application/products/product_bloc.dart';

class CartButton extends StatelessWidget {
  final CustomColorSet colors;

  const CartButton({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return ButtonEffectAnimation(
      onTap: () {
        context.read<CartBloc>().add(CartEvent.insertCart(
              context: context,
              onSuccess: () {
                context
                    .read<ProductBloc>()
                    .add(const ProductEvent.updateState());
              },
            ));
        AppRoute.goCartPage(context);
      },
      child: BlurWrap(
        radius: BorderRadius.circular(AppConstants.radius.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.r),
          decoration: BoxDecoration(
              color: colors.bottomBarColor,
              borderRadius: BorderRadius.circular(AppConstants.radius.r)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              16.horizontalSpace,
              SvgPicture.asset(
                "assets/svg/selectBag.svg",
                height: 16.r,
              ),
              8.horizontalSpace,
              Text(
                AppHelpers.getTranslation(TrKeys.goToCart),
                style: CustomStyle.interNormal(color: colors.white, size: 16),
              ),
              24.horizontalSpace,
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary,
                ),
                padding: EdgeInsets.all(10.r),
                child: Text(
                  LocalStorage.getCartList()
                      .where((element) => element.count > 0)
                      .length
                      .toString(),
                  style: CustomStyle.interNormal(color: colors.white, size: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
