import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'bloc/theme_cubit.dart';

ThemeData getTheme(
  ThemeCategory themeCategory,
  ThemeColor themeColor,
  BuildContext context,
) {
  switch (themeCategory) {
    case ThemeCategory.system:
      var brightness = MediaQuery.of(context).platformBrightness;
      if (brightness == Brightness.dark) {
        return _getAmoledDarkTheme(themeColor);
      } else {
        return _getLightTheme(themeColor);
      }
    case ThemeCategory.light:
      return _getLightTheme(themeColor);
    case ThemeCategory.dark:
      return _getAmoledDarkTheme(themeColor);
  }
}

ThemeData _getLightTheme(ThemeColor themeColor) {
  // Get FlexSchemeColor based on user selection
  final FlexSchemeColor schemeColor = _getSchemeColorFromThemeColor(
    themeColor,
    true,
  );

  // Use FlexColorScheme to create a cohesive theme
  return FlexThemeData.light(
    colors: schemeColor,
    surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
    blendLevel: 9,
    subThemesData: const FlexSubThemesData(
      interactionEffects: false,
      blendOnLevel: 10,
      blendOnColors: false,
      buttonMinSize: Size(20, 36),
      buttonPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textButtonRadius: 16.0,
      elevatedButtonRadius: 16.0,
      elevatedButtonSchemeColor: SchemeColor.primary,
      elevatedButtonSecondarySchemeColor: SchemeColor.onPrimary,
      outlinedButtonRadius: 16.0,
      inputDecoratorRadius: 8.0,
      inputDecoratorUnfocusedHasBorder: true,
      inputDecoratorFocusedHasBorder: true,
      inputDecoratorFillColor: Colors.transparent,
      chipRadius: 8.0,
      cardRadius: 6.0,
      popupMenuRadius: 8.0,
      dialogRadius: 8.0,
      bottomSheetRadius: 20.0,
      bottomNavigationBarMutedUnselectedLabel: false,
      bottomNavigationBarMutedUnselectedIcon: false,
      navigationBarMutedUnselectedLabel: false,
      navigationBarMutedUnselectedIcon: false,
      navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      navigationBarSelectedIconSchemeColor: SchemeColor.primary,
    ),
    keyColors: const FlexKeyColors(),
    useMaterial3: true,
    // Add typography with Google Fonts
    // fontFamily: GoogleFonts.openSans().fontFamily,
  );
  // .copyWith(textTheme: _getTextTheme(Brightness.light));
}

ThemeData _getAmoledDarkTheme(ThemeColor themeColor) {
  final FlexSchemeColor schemeColor = _getSchemeColorFromThemeColor(
    themeColor,
    false,
  );

  return FlexThemeData.dark(
    colors: schemeColor,
    surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
    blendLevel: 15,
    subThemesData: const FlexSubThemesData(
      interactionEffects: false,
      blendOnLevel: 20,
      buttonMinSize: Size(20, 36),
      buttonPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textButtonRadius: 16.0,
      elevatedButtonRadius: 16.0,
      elevatedButtonSchemeColor: SchemeColor.primary,
      elevatedButtonSecondarySchemeColor: SchemeColor.onPrimary,
      outlinedButtonRadius: 16.0,
      inputDecoratorRadius: 8.0,
      inputDecoratorUnfocusedHasBorder: true,
      inputDecoratorFocusedHasBorder: true,
      inputDecoratorFillColor: Colors.transparent,
      chipRadius: 8.0,
      cardRadius: 6.0,
      popupMenuRadius: 8.0,
      dialogRadius: 8.0,
      bottomSheetRadius: 20.0,
    ),
    keyColors: const FlexKeyColors(),
    useMaterial3: true,
    // fontFamily: GoogleFonts.openSans().fontFamily,
    darkIsTrueBlack: true,
  ).copyWith(
    // textTheme: _getTextTheme(Brightness.dark),
    colorScheme: FlexThemeData.dark(
      colors: schemeColor,
      useMaterial3: true,
    ).colorScheme.copyWith(
      // AMOLED uses pure black for surface
      surface: Colors.black,
      background: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.black,
  );
}

FlexSchemeColor _getSchemeColorFromThemeColor(
  ThemeColor themeColor,
  bool isLight,
) {
  switch (themeColor) {
    case ThemeColor.blue:
      return isLight
          ? FlexSchemeColor.from(
            primary: Colors.blue,
            secondary: Colors.blue.shade700,
          )
          : FlexSchemeColor.from(
            primary: Colors.blue.shade400,
            secondary: Colors.blue.shade200,
          );
    case ThemeColor.green:
      return isLight
          ? FlexSchemeColor.from(
            primary: Colors.green,
            secondary: Colors.green.shade700,
          )
          : FlexSchemeColor.from(
            primary: Colors.green.shade400,
            secondary: Colors.green.shade200,
          );
    case ThemeColor.purple:
      return isLight
          ? FlexSchemeColor.from(
            primary: Colors.purple,
            secondary: Colors.purple.shade700,
          )
          : FlexSchemeColor.from(
            primary: Colors.purple.shade400,
            secondary: Colors.purple.shade200,
          );
    case ThemeColor.orange:
      return isLight
          ? FlexSchemeColor.from(
            primary: Colors.orange,
            secondary: Colors.orange.shade700,
          )
          : FlexSchemeColor.from(
            primary: Colors.orange.shade400,
            secondary: Colors.orange.shade200,
          );
    case ThemeColor.pink:
      return isLight
          ? FlexSchemeColor.from(
            primary: Colors.pink,
            secondary: Colors.pink.shade700,
          )
          : FlexSchemeColor.from(
            primary: Colors.pink.shade400,
            secondary: Colors.pink.shade200,
          );
  }
}

// TextTheme _getTextTheme(Brightness brightness) {
//   final headlineColor =
//       brightness == Brightness.light ? Colors.black87 : Colors.white;
//   const headlineWeight = FontWeight.w900;
//   const headlineHeight = 1.2;
//   const headlineLetterSpacing = 1.2;

//   final titleColor =
//       brightness == Brightness.light ? Colors.black87 : Colors.white;
//   const titleWeight = FontWeight.bold;
//   const titleHeight = 1.2;
//   const titleLetterSpacing = -0.96;

//   final bodyColor =
//       brightness == Brightness.light ? Colors.black87 : Colors.white;
//   const bodyWeight = FontWeight.normal;
//   const bodyHeight = 1.5;
//   const bodyLetterSpacing = 0.0;

//   final labelColor = titleColor;

//   return TextTheme(
//     // Diplay
//     displayLarge: GoogleFonts.montserrat(
//       fontSize: 24,
//       height: headlineHeight,
//       letterSpacing: headlineLetterSpacing,
//       color: headlineColor,
//       fontWeight: headlineWeight,
//     ),
//     displayMedium: GoogleFonts.montserrat(
//       fontSize: 16,
//       height: headlineHeight,
//       letterSpacing: headlineLetterSpacing,
//       color: headlineColor,
//       fontWeight: headlineWeight,
//     ),
//     displaySmall: GoogleFonts.montserrat(
//       fontSize: 14,
//       height: headlineHeight,
//       letterSpacing: headlineLetterSpacing,
//       color: headlineColor,
//       fontWeight: headlineWeight,
//     ),
//     // Headline
//     headlineLarge: GoogleFonts.openSans(
//       fontSize: 24,
//       height: headlineHeight,
//       letterSpacing: headlineLetterSpacing,
//       color: headlineColor,
//       fontWeight: headlineWeight,
//     ),
//     headlineMedium: GoogleFonts.openSans(
//       fontSize: 20,
//       height: headlineHeight,
//       letterSpacing: headlineLetterSpacing,
//       color: headlineColor,
//       fontWeight: headlineWeight,
//     ),
//     headlineSmall: GoogleFonts.openSans(
//       fontSize: 18,
//       height: headlineHeight,
//       letterSpacing: headlineLetterSpacing,
//       color: headlineColor,
//       fontWeight: headlineWeight,
//     ),

//     // Title
//     titleLarge: GoogleFonts.openSans(
//       fontSize: 20,
//       height: titleHeight,
//       letterSpacing: titleLetterSpacing,
//       color: titleColor,
//       fontWeight: titleWeight,
//     ),
//     titleMedium: GoogleFonts.openSans(
//       fontSize: 18,
//       height: titleHeight,
//       letterSpacing: titleLetterSpacing,
//       color: titleColor,
//       fontWeight: titleWeight,
//     ),
//     titleSmall: GoogleFonts.openSans(
//       fontSize: 14,
//       height: titleHeight,
//       letterSpacing: titleLetterSpacing,
//       color: titleColor,
//       fontWeight: titleWeight,
//     ),

//     // Body
//     bodyLarge: GoogleFonts.openSans(
//       fontSize: 18,
//       height: bodyHeight,
//       letterSpacing: bodyLetterSpacing,
//       color: bodyColor,
//       fontWeight: bodyWeight,
//     ),
//     bodyMedium: GoogleFonts.openSans(
//       fontSize: 14,
//       height: bodyHeight,
//       letterSpacing: bodyLetterSpacing,
//       color: bodyColor,
//       fontWeight: bodyWeight,
//     ),
//     bodySmall: GoogleFonts.openSans(
//       fontSize: 12,
//       height: bodyHeight,
//       color: bodyColor,
//       fontWeight: bodyWeight,
//     ),

//     // Label
//     labelLarge: GoogleFonts.openSans(
//       fontSize: 16,
//       height: bodyHeight,
//       letterSpacing: bodyLetterSpacing,
//       color: labelColor,
//       fontWeight: bodyWeight,
//     ),
//     labelMedium: GoogleFonts.openSans(
//       fontSize: 14,
//       height: bodyHeight,
//       letterSpacing: bodyLetterSpacing,
//       color: labelColor,
//       fontWeight: bodyWeight,
//     ),
//     labelSmall: GoogleFonts.openSans(
//       fontSize: 12,
//       height: bodyHeight,
//       letterSpacing: bodyLetterSpacing,
//       color: labelColor,
//       fontWeight: bodyWeight,
//     ),
//   );
// }
