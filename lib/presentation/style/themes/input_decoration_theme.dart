import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/presentation/style/style.dart';

InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
  focusColor: CustomStyle.primary,
  errorStyle: CustomStyle.interRegular(color: CustomStyle.red, size: 12),
  contentPadding: REdgeInsets.symmetric(vertical: 20, horizontal: 12),
  hintStyle: CustomStyle.interRegular(color: CustomStyle.textHint, size: 14),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppConstants.radius.r),
    borderSide: const BorderSide(color: CustomStyle.transparent),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppConstants.radius.r),
    borderSide: const BorderSide(color: CustomStyle.transparent),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppConstants.radius.r),
    borderSide: const BorderSide(color: CustomStyle.transparent),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppConstants.radius.r),
    borderSide: const BorderSide(color: CustomStyle.red),
  ),
);

OutlineInputBorder secondaryOutlineInputBorder(BuildContext context) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppConstants.radius.r),
    borderSide: BorderSide(
      color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.15),
    ),
  );
}
