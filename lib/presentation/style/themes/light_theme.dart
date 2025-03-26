import 'package:goshops/presentation/style/style.dart';
import 'package:flutter/material.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'input_decoration_theme.dart';
import 'checkbox_theme_data.dart';
import 'button_theme.dart';
import 'theme_data.dart';

ThemeData lightTheme(CustomColorSet colors) {
  return ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    primaryColor: CustomStyle.primary,
    scaffoldBackgroundColor: colors.backgroundColor,
    iconTheme: IconThemeData(color: colors.textBlack),
    textTheme: TextTheme(
      bodyMedium: CustomStyle.interNormal(color: colors.textBlack),
    ),
    elevatedButtonTheme: elevatedButtonThemeData,
    outlinedButtonTheme: outlinedButtonTheme(),
    // textButtonTheme: textButtonThemeData,
    inputDecorationTheme: lightInputDecorationTheme,
    checkboxTheme: checkboxThemeData.copyWith(
      side: BorderSide(color: colors.textBlack),
    ),
    textSelectionTheme:
        const TextSelectionThemeData(cursorColor: CustomStyle.primary),
    appBarTheme: appBarLightTheme(colors),
    scrollbarTheme: scrollbarThemeData,
    dataTableTheme: dataTableLightThemeData,
    expansionTileTheme: ExpansionTileThemeData(
        collapsedIconColor: colors.textBlack,
        iconColor: colors.textBlack
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: CustomStyle.primary,
      primary: CustomStyle.primary,
      error: CustomStyle.red,
    ),
  );
}
