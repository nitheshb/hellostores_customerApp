import 'package:goshops/app_constants.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

AppBarTheme appBarLightTheme(CustomColorSet colors) {
  return AppBarTheme(
    backgroundColor: colors.backgroundColor,
    elevation: 1,
    iconTheme: IconThemeData(color: colors.textBlack, size: 20.r),
    titleTextStyle: CustomStyle.interNormal(size: 18, color: colors.textBlack),
  );
}

ScrollbarThemeData scrollbarThemeData = ScrollbarThemeData(
  trackColor: WidgetStateProperty.all(CustomStyle.primary),
);

DataTableThemeData dataTableLightThemeData = DataTableThemeData(
  columnSpacing: 24,
  headingRowColor: WidgetStateProperty.all(CustomStyle.black),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius.r)),
    border: Border.all(color: CustomStyle.black),
  ),
  dataTextStyle: CustomStyle.interNormal(size: 12, color: CustomStyle.black),
);
