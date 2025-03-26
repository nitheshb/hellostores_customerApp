import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goshops/application/shop/shop_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class ShopAvatar extends StatelessWidget {
  final CustomColorSet colors;

  const ShopAvatar({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        return SizedBox(
          height: 250.r,
          width: MediaQuery.sizeOf(context).width,
          child: Stack(
            children: [
              CustomNetworkImage(
                  url: state.shop?.backgroundImg ?? state.shop?.logoImg,
                  height: 260.h + MediaQuery.paddingOf(context).top,
                  width: double.infinity,
                  radius: 0),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Text(
                        state.shop?.translation?.title ?? "",
                        style: CustomStyle.interSemi(
                            color: colors.white, size: 24),
                      ),
                      10.verticalSpace,
                      Row(
                        children: [
                          BlurWrap(
                            radius: BorderRadius.circular(100.r),
                            child: Container(
                              color: colors.white.withOpacity(0.2),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.r, vertical: 12.r),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppHelpers.shopTime(state.shop?.workingDays,
                                        state.shop?.open),
                                    style: CustomStyle.interNormal(
                                        color: colors.white, size: 16),
                                  ),
                                  24.horizontalSpace,
                                  SvgPicture.asset(
                                    "assets/svg/start.svg",
                                    width: 16.r,
                                  ),
                                  4.horizontalSpace,
                                  Text(
                                    state.shop?.rAvg
                                            ?.toStringAsPrecision(2) ??
                                        "0.0",
                                    style: CustomStyle.interNoSemi(
                                        color: colors.white, size: 12),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          SecondButton(
                            title: AppHelpers.getTranslation(TrKeys.seeReview),
                            bgColor: colors.primary,
                            titleColor: colors.white,
                            onTap: () {
                              AppRoute.goReviewPage(
                                  context: context,
                                  colors: colors,
                                  shopId: state.shop?.id);
                            },
                            radius: 100.r,
                            titleSize: 16,
                          ),
                        ],
                      ),
                      10.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ShopName extends StatelessWidget {
  final CustomColorSet colors;

  const ShopName({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(builder: (context, state) {
      return Stack(
        children: [
          Positioned(
            left: 14.r,
            right: 14.r,
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  state.shop?.translation?.title ?? "",
                  style:
                      CustomStyle.interSemi(color: colors.textBlack, size: 21),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
