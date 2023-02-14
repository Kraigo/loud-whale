import 'package:flutter/material.dart';

class AppTheme {
  static const MaterialColor purple =
      MaterialColor(_purplePrimaryValue, <int, Color>{
    50: Color(0xFFEBEBFF),
    100: Color(0xFFCDCEFF),
    200: Color(0xFFACADFF),
    300: Color(0xFF8B8CFF),
    400: Color(0xFF7273FF),
    500: Color(_purplePrimaryValue),
    600: Color(0xFF5152FF),
    700: Color(0xFF4848FF),
    800: Color(0xFF3E3FFF),
    900: Color(0xFF2E2EFF),
  });
  static const int _purplePrimaryValue = 0xFF595AFF;

  static const MaterialColor purpleAccent =
      MaterialColor(_purpleAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_purpleAccentValue),
    400: Color(0xFFDADAFF),
    700: Color(0xFFC0C0FF),
  });
  static const int _purpleAccentValue = 0xFFFFFFFF;

  static const Color favouriteColor = Color(0xffca8f04);
  static const Color followColor = Color(0xff8c8dff);
  static const Color reblogColor = Color.fromARGB(255, 20, 156, 34);
}
