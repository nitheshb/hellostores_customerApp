import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/presentation/style/style.dart';

ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    padding: REdgeInsets.all(16),
    backgroundColor: CustomStyle.primary,
    minimumSize: const Size(double.infinity, 32),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radius.r),
    ),
  ),
);

TextButtonThemeData textButtonThemeData = TextButtonThemeData(
  style: ButtonStyle(
    foregroundColor: WidgetStateProperty.all(CustomStyle.success),
    textStyle: WidgetStateProperty.all(
      CustomStyle.interSemi(size: 16, color: CustomStyle.black),
    ),
  ),
);

OutlinedButtonThemeData outlinedButtonTheme(
    {Color borderColor = CustomStyle.primary}) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: CustomStyle.success,
      padding: REdgeInsets.all(24),
      minimumSize: const Size(double.infinity, 32),
      side: BorderSide(width: 1.5, color: borderColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radius.r),
      ),
    ),
  );
}
