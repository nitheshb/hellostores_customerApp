import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/banner/banner_bloc.dart';
import 'package:goshops/infrastructure/model/response/banners_paginate_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/components/make_gradient_mask.dart';

import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../components/shimmer/banner_shimmer.dart';

class DiscountBannerList extends StatelessWidget {
  final PageController pageController;
  final CustomColorSet colors;
  final RefreshController controller;
  final VoidCallback onLoading;

  const DiscountBannerList(
      {super.key,
      required this.pageController,
      required this.colors,
      required this.controller,
      required this.onLoading});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8.r),
          child: Column(
            children: [
              state.discounts.isNotEmpty || state.isLoadingBanner
                  ? SizedBox(
                      height: 180.r,
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              if (state.discounts.isNotEmpty)
                                Expanded(
                                  child: SmartRefresher(
                                    enablePullDown: false,
                                    enablePullUp: true,
                                    controller: controller,
                                    scrollDirection: Axis.horizontal,
                                    onLoading: onLoading,
                                    child: PageView.builder(
                                        controller: pageController,
                                        itemCount: state.discounts.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return _bannerItem(
                                            context,
                                            state.discounts[index],
                                          );
                                        }),
                                  ),
                                ),
                              if (state.isLoadingBanner) const BannerShimmer(),
                            ],
                          ),
                          if (state.discounts.length > 1)
                            Positioned(
                              bottom: 15.r,
                              left: 15.r,
                              right: 0.r,
                              child: Center(
                                child: SizedBox(
                                  height: 12.r,
                                  child: SmoothPageIndicator(
                                      controller: pageController,
                                      count: state.discounts.length,
                                      effect: ScrollingDotsEffect(
                                        dotWidth: 28.r,
                                        strokeWidth: 28.r,
                                        activeDotScale: 1,
                                        dotHeight: 4.r,
                                        activeDotColor:
                                            colors.white.withOpacity(0.8),
                                        dotColor: colors.white.withOpacity(0.4),
                                        paintStyle: PaintingStyle.fill,
                                      ),
                                      onDotClicked: (index) {}),
                                ),
                              ),
                            )
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              6.verticalSpace,
              // if (state.banners.length > 2 && AppHelpers.getType() == 0)
              //   SizedBox(
              //       height: 20,
              //       child: SmoothPageIndicator(
              //           controller: pageController,
              //           count: state.banners.length,
              //           effect: ScrollingDotsEffect(
              //               dotWidth: 6.r,
              //               strokeWidth: 10.r,
              //               activeDotScale: 1.7,
              //               dotHeight: 6.r,
              //               activeDotColor: colors.textBlack,
              //               paintStyle: PaintingStyle.fill),
              //           onDotClicked: (index) {}))
            ],
          ),
        );
      },
    );
  }

  Padding _bannerItem(BuildContext context, BannerData banner) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppHelpers.getType() == 3 ? 0 : 16.r),
      child: ButtonEffectAnimation(
        onTap: () {
          AppRoute.goProductList(
            context: context,
            title: banner.translation?.description ?? "",
            bannerId: banner.id,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: colors.icon),
            borderRadius: BorderRadius.circular(
              AppConstants.radius.r,
            ),
          ),
          child: MakeGradientMask(
            child: CustomNetworkImage(
              url: banner.galleries?.first.path,
              preview: banner.galleries?.first.preview,
              height: double.infinity,
              width: double.infinity,
              radius: AppConstants.radius,
            ),
          ),
        ),
      ),
    );
  }
}
