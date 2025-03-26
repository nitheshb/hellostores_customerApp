import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class BottomNavigationBarButton extends StatelessWidget {
  final IconData iconData;
  final bool isSelected;
  final String label;
  final VoidCallback onTap;
  final CustomColorSet colors;

  const BottomNavigationBarButton({
    super.key,
    required this.iconData,
    required this.isSelected,
    required this.label,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(AppConstants.radius.r),
      color: isSelected ? colors.textBlack : colors.newBoxColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.radius.r),
        onTap: onTap,
        child: Container(
          height: 36.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radius.r),
          ),
          padding: REdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: 20.r,
                color: isSelected
                    ? colors.textWhite
                    : colors.textHint,
              ),
              10.horizontalSpace,
              Text(
                label.toUpperCase(),
                style: CustomStyle.interNoSemi(
                  size: 11,
                  color: isSelected
                      ? colors.textWhite
                      : colors.textHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
