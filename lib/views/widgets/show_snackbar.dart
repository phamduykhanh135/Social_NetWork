
import 'package:flutter/material.dart';
import 'package:network/app/colors.dart';

void showSnackBar(
  BuildContext context, {
  required String message,
  Duration duration = const Duration(seconds: 3),
  Color snackbarBackgroundColor = AppColor.primaryLight,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: snackbarBackgroundColor,
      duration: duration,
    ),
  );
}
