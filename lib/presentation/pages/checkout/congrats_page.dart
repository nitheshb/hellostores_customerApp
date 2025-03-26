import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/app_assets.dart';
import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/style/style.dart';

class CongratsPage extends StatelessWidget {
  final bool isOrder;
  final VoidCallback? onTap;

  const CongratsPage({super.key, this.isOrder = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: (colors) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              Text(
                AppHelpers.getTranslation(TrKeys.checkout),
                style: CustomStyle.interSemi(color: colors.textBlack, size: 22),
              ),
              (MediaQuery.sizeOf(context).height / 4).verticalSpace,
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    padding: REdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: CustomStyle.primary.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      Assets.svgAccepted,
                      colorFilter: const ColorFilter.mode(
                        CustomStyle.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              24.verticalSpace,
              if (isOrder)
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppHelpers.getTranslation(TrKeys.congrats),
                        style: CustomStyle.interBold(
                            color: colors.textBlack, size: 20),
                      ),
                      6.verticalSpace,
                      Text(
                        AppHelpers.getTranslation(TrKeys.thankYouPurchase),
                        style: CustomStyle.interNormal(
                            color: colors.textBlack, size: 14),
                      ),
                      Text(
                        AppHelpers.getTranslation(TrKeys.yourOrderShipping),
                        style: CustomStyle.interNormal(
                            color: colors.textBlack, size: 14),
                      ),
                    ],
                  ),
                ),
              if (!isOrder)
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppHelpers.getTranslation(TrKeys.congrats),
                        style: CustomStyle.interBold(
                            color: colors.textBlack, size: 20),
                      ),
                      6.verticalSpace,
                      Text(
                        AppHelpers.getTranslation(TrKeys.paymentSuccessful),
                        style: CustomStyle.interNormal(
                            color: colors.textBlack, size: 14),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingButton: (colors) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.r),
        child: SizedBox(
          height: 48.r,
          child: CustomButton(
            title: AppHelpers.getTranslation(
                isOrder ? TrKeys.returnHome : TrKeys.ok),
            bgColor: colors.primary,
            titleColor: colors.white,
            onTap: () {
              onTap ?? Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
