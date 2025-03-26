import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/app_assets.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';

class InviteItem extends StatelessWidget {
  const InviteItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          AppRoute.goMyReferral(context: context);
        },
        child: Stack(
          children: [
            Container(
              margin: REdgeInsets.only(top: 32),
              width: double.infinity,
              height: 160.r,
              decoration: BoxDecoration(
                color: CustomStyle.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppConstants.radius.r),
              ),
            ),
            Positioned(
              bottom: -44.r,
              left: 16.r,
              child: Image.asset(
                Assets.imagesInviteLeftBottom,
                width: 116.r,
              ),
            ),
            Positioned(
              bottom: -44.r,
              right: 16.r,
              child: Image.asset(
                Assets.imagesInviteRightBottom,
                width: 140.r,
              ),
            ),
            Positioned(
              top: 48.r,
              left: 16.r,
              child: Image.asset(
                Assets.imagesInviteLeftTop,
                width: 34.r,
              ),
            ),
            Positioned(
              top: 0.r,
              right: 16.r,
              child: Image.asset(
                Assets.imagesInviteRightTop,
                width: 60.r,
              ),
            ),
            Positioned(
              bottom: 60.r,
              top: 80.r,
              left: 24.r,
              right: 24.r,
              child: Text(
                AppHelpers.getTranslation(TrKeys.inviteFriendGetMoney),
                style: CustomStyle.interNormal(
                  color: CustomStyle.primary,
                  size: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
