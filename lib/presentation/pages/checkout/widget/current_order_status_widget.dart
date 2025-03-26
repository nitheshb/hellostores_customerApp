import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class CurrentOrderStatusWidget extends StatelessWidget {
  final String title;
  final bool isDone;
  final bool isActive;
  final IconData iconData;
  final CustomColorSet colors;

  const CurrentOrderStatusWidget({
    super.key,
    required this.title,
    required this.isDone,
    required this.isActive,
    required this.iconData,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40.r,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  height: 5.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    color: (isDone || isActive)
                        ? CustomStyle.greenColor
                        : CustomStyle.icon,
                  ),
                ),
                isActive
                    ? Container(
                        width: 40.r,
                        height: 40.r,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: colors.newBoxColor,
                          border: Border.all(
                            color: CustomStyle.greenColor,
                            width: 3.r,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          iconData,
                          size: 20.r,
                          color: colors.textBlack,
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
          4.verticalSpace,
          Text(
            title,
            style: CustomStyle.interNormal(
              color: colors.textBlack,
              size: 14
            ),
          )
        ],
      ),
    );
  }
}
