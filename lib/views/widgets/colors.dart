import 'package:flutter/material.dart';

abstract class AppColor {
  static const Color primaryLight = Color(0xFF888BF4); // Light purple
  static const Color primaryDark = Color(0xFF5151C6); // Dark purple
  static const Color greyColor = Colors.grey;
  static const Color selectedColor = Colors.white;
}

class TextColor extends AppColor {
  static const Color hintTextColor = Color.fromRGBO(189, 189, 189, 1);
  static const Color errorTextColor = Colors.red;
  static const Color textWhite = Colors.white;
  static const Color textBlack = Colors.black;
}

class BackgroundColor extends AppColor {
  static const Color backgroundWhite = Colors.white;
  static const Color inputBackgroundColor = Color.fromRGBO(243, 245, 247, 1);
  static const Color transparentBackground = Colors.transparent;
  static const Color descriptionBackground = Color.fromRGBO(241, 241, 254, 1);
  static const Color getStartedBackground = Color.fromRGBO(208, 208, 208, 0.3);
  static const Color googleSignInBackground = Color.fromRGBO(227, 228, 252, 1);
}

class ShadowColor extends AppColor {
  static const Color transparentShadow = Colors.transparent;
}
