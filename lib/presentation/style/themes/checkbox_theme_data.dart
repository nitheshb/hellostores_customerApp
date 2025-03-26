import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/presentation/style/style.dart';

CheckboxThemeData checkboxThemeData = CheckboxThemeData(
  fillColor: WidgetStateProperty.all(CustomStyle.primary),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppConstants.radius.r),
  ),
  side: const BorderSide(color: CustomStyle.primary),
);
