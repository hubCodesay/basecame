import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeColors {
  static const background = Color(0xFFFFFFFF);
  static const pureBlackColor = Color(0xFF000000);
  static const blackColor = Color(0xFF1C1B1F);
  static const switchColor = Color(0xFFD1D1D6);
  static const silverColor = Color(0xFFEFF1F5);
  static const greyColor = Color(0xFFA09CAB);
  static const grey2Color = Color(0xFFECECEC);
  static const grey3Color = Color(0xFFD9D9D9);
  static const grey4Color = Color(0xFFE8E8E8);
  static const cloudGreyColor = Color(0xFFD0D0D0);
  static const redColor50 = Color(0x80FF383C);
  static const primaryColor = ThemeColors.blackColor;
  static const primaryTextColor = ThemeColors.background;
  static const bodyTextColor = ThemeColors.blackColor;
}

const _fontFamily = 'Inter';
const _navigationTextSize = 11.0;
const _textSmallSize = 12.0;
const _textSize = 14.0;
const _titleSmallSize = 16.0;
const _inputTextSize = 16.0;
const _buttonTextSize = 16.0;
const _titleSize = 20.0;

const buttonBorderRadius = 12.0;

const horizontalOffsetSpace = 4.0;
const vertSpaceDefault = 8.0;
const vertSpace = 12.0;

const horizontalSpace = 8.0;
const paddingHorizontal = 16.0;

const sizeIcon = 24.0;

final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: _fontFamily,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,

  // Основний текст
  textTheme: TextTheme(
    // Для Загаловків
    titleMedium: TextStyle(
      fontSize: _titleSmallSize,
      fontFamily: 'Inter',
      color: ThemeColors.blackColor,
      fontWeight: FontWeight.w600,
      height: 1.5,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontFamily: 'Inter',
      color: ThemeColors.blackColor,
      fontWeight: FontWeight.w600,
    ),

    // Основний текст
    // bodyMedium: TextStyle(
    //   fontSize: _textSize,
    //   color: ThemeColors.blackColor,
    //   letterSpacing: -0.1,
    //   height: 1.45,
    // ),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: ThemeColors.background,
    selectedItemColor: ThemeColors.blackColor,
    unselectedItemColor: ThemeColors.greyColor,
    selectedLabelStyle: TextStyle(
      fontSize: _navigationTextSize,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: _navigationTextSize,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w600,
    ),
  ),

  primaryColor: ThemeColors.blackColor,
  scaffoldBackgroundColor: ThemeColors.background,

  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStatePropertyAll(EdgeInsets.all(14)),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return ThemeColors.primaryColor.withAlpha(200);
        }
        return ThemeColors.primaryColor;
      }),
      foregroundColor: WidgetStatePropertyAll(ThemeColors.primaryTextColor),
      textStyle: WidgetStatePropertyAll(
        const TextStyle(
          fontSize: _buttonTextSize,
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStatePropertyAll(EdgeInsets.all(14)),
      foregroundColor: WidgetStatePropertyAll(ThemeColors.blackColor),
      textStyle: WidgetStatePropertyAll(
        const TextStyle(
          fontSize: _buttonTextSize,
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
      ),
      side: WidgetStatePropertyAll(
        BorderSide(color: ThemeColors.silverColor, width: 1),
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: ThemeColors.background,
    hintStyle: TextStyle(
      color: ThemeColors.greyColor,
      fontSize: _inputTextSize,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: ThemeColors.silverColor, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: ThemeColors.silverColor, width: 2),
    ),
  ),

  // 👇 тільки тут задається курсор
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: ThemeColors.blackColor,
    selectionColor: ThemeColors.silverColor,
    selectionHandleColor: ThemeColors.silverColor,
  ),
);

extension ThemePlatformExtension on ThemeData {
  bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  bool get isCupertino => [
    TargetPlatform.iOS,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
  Color get cupertinoAlertColor => primaryColor;
  Color get cupertinoActionColor => const Color(0xFF3478F7);
}

final silverButtonStyle = ButtonStyle(
  padding: WidgetStatePropertyAll(EdgeInsets.all(14)),
  backgroundColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.disabled)) {
      return ThemeColors.silverColor.withAlpha(200);
    }
    return ThemeColors.silverColor;
  }),
  foregroundColor: WidgetStatePropertyAll(ThemeColors.blackColor),
  textStyle: WidgetStatePropertyAll(
    const TextStyle(
      fontSize: _buttonTextSize,
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w600,
    ),
  ),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonBorderRadius),
    ),
  ),
);
