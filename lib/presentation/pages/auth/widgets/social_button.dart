import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/style/style.dart';

class SocialButton extends StatelessWidget {
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final VoidCallback onTap;

  const SocialButton(
      {super.key,
      required this.bgColor,
      required this.icon,
      required this.onTap,
      required this.iconColor})
     ;

  @override
  Widget build(BuildContext context) {
    return ButtonEffectAnimation(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppConstants.radius.r),
        ),
        padding: EdgeInsets.all(14.r),
        child: icon == FlutterRemix.google_fill
            ? Row(
                children: [
                  Icon(icon, color: iconColor),
                  12.horizontalSpace,
                  Text(
                    AppHelpers.getTranslation(TrKeys.continueWithGoogle),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: CustomStyle.interRegular(color: iconColor),
                  ),
                ],
              )
            : Icon(
                icon,
                color: iconColor,
              ),
      ),
    );
  }
}
