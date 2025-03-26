import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class CustomStyle {
  CustomStyle._();

  /// colors.
  static const Color primary = Color(0xFF50C878);

  static const Color black = Colors.black;

  static const Color rate = Color(0xffFFA826);

  static const Color greenColor = Color(0xff16AA16);

  static const Color unselectColor = Color(0xffF4F8F4);

  static const Color white = Colors.white;

  static const Color whiteWithOpacity = Color(0x30ffffff);

  static const Color red = Color(0xffFE0000);

  static const Color success = Color(0xff31D0AA);

  static const Color icon = Color(0x30B1B1B1);

  static const Color textHint = Color(0xff838383);

  static const Color transparent = Colors.transparent;

  static const Color bgDark = Color(0xFF1E272E);

  static const Color socialButtonDark = Color(0xff33393F);

  static const Color socialButtonLight = Color(0x40ffffff);

  static const Color bottomBarColorDark = Color(0xff444444);

  static const Color bottomBarColorLight = Color(0xff000000);

  static const Color categoryDark = Color(0xff33393F);

  static const Color dividerColor = Color(0xffF3F3F3);

  static const Color seeAllColor = Color(0xff289AB3);

  static const Color subCategory = Color(0xffF6F6F6);

  static const Color imgBackground = Color(0xffEDEDEE);

  static const Color unselectLayout = Color(0xffAEAEAE);

  static const Color unselectTabBar = Color(0xffA0A09C);

  static Color shimmerBase = Colors.grey.shade300;
  static const Color bannerGradient2 = Color.fromRGBO(0, 0, 0, 0);
  static const Color bannerGradient1 = Color.fromRGBO(0, 0, 0, 0.3);
  static const Color bottomNavigationShadow =
      Color.fromRGBO(207, 207, 207, 0.65);

  ///fonts.
  static interBold(
          {double size = 18,
          required Color color,
          FontStyle fontStyle = FontStyle.normal,
          double letterSpacing = 0}) =>
      GoogleFonts.k2d(
          fontSize: size.sp,
          fontWeight: FontWeight.bold,
          color: color,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing.sp,
          decoration: TextDecoration.none);

  static interSemi(
          {double size = 18,
          required Color color,
          FontStyle fontStyle = FontStyle.normal,
          TextDecoration decoration = TextDecoration.none,
          double letterSpacing = 0}) =>
      GoogleFonts.k2d(
          fontSize: size.sp,
          fontWeight: FontWeight.w700,
          color: color,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing.sp,
          decoration: decoration);

  static interNoSemi(
          {double size = 18,
          required Color color,
          FontStyle fontStyle = FontStyle.normal,
          TextDecoration decoration = TextDecoration.none,
          double letterSpacing = 0}) =>
      GoogleFonts.k2d(
          fontSize: size.sp,
          fontWeight: FontWeight.w600,
          color: color,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing.sp,
          decoration: decoration);

  static interNormal(
          {double size = 16,
          required Color color,
          FontStyle fontStyle = FontStyle.normal,
          TextDecoration textDecoration = TextDecoration.none,
          double letterSpacing = 0}) =>
      GoogleFonts.k2d(
          fontSize: size.sp,
          fontWeight: FontWeight.w500,
          color: color,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing.sp,
          decoration: textDecoration);

  static interRegular(
          {double size = 16,
          FontStyle fontStyle = FontStyle.normal,
          required Color color,
          TextDecoration textDecoration = TextDecoration.none,
          double letterSpacing = 0}) =>
      GoogleFonts.k2d(
          fontSize: size,
          fontWeight: FontWeight.w400,
          color: color,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing.sp,
          decoration: textDecoration);
}
