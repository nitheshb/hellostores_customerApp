import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/style/style.dart';

class BottomItem extends StatelessWidget {
  final bool isActive;
  final int bagCount;
  final String selectIcon;
  final String icon;
  final String? image;
  final String? name;
  final VoidCallback onTap;

  const BottomItem({
    super.key,
    required this.isActive,
    required this.selectIcon,
    required this.icon,
    required this.onTap,
    this.image,
    this.bagCount = -1,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ButtonEffectAnimation(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(top: icon.isNotEmpty ? 16.r : 8.r),
          child: Column(
            children: [
              icon.isNotEmpty
                  ? Badge(
                      label: Text(bagCount.toString()),
                      isLabelVisible: bagCount != -1,
                      child: SvgPicture.asset(
                        isActive ? selectIcon : icon,
                        height: 20.r,
                      ),
                    )
                  : CustomNetworkImage(
                      url: image,
                      height: 40,
                      width: 40,
                      radius: 20,
                      name: name,
                    ),
              6.verticalSpace,
              if (isActive)
                Container(
                  width: 4.r,
                  height: 4.r,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: CustomStyle.primary),
                )
            ],
          ),
        ),
      ),
    );
  }
}
