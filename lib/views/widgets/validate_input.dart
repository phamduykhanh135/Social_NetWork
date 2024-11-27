import 'package:network/app/messages.dart';
import 'package:network/app/regex.dart';
import 'package:network/app/texts.dart';

String validateEmail({
  required String email,
}) {
  if (email.isEmpty) {
    return ErrorTexts.emptyEmail;
  } else if (!emailRegex.hasMatch(email.trim())) {
    return ErrorTexts.invalidEmail;
  }

  return '';
}

String validatePassword({
  required String password,
}) {
  if (password.isEmpty) {
    return ErrorTexts.emptyPassword;
  } else if (!passwordRegex.hasMatch(password.trim())) {
    return ErrorTexts.invalidPassword;
  }

  return '';
}

String validateConfirmPassword({
  required String password,
  required String confirmPassword,
}) {
  if (confirmPassword.isEmpty) {
    return ErrorTexts.emptyConfirmPassword;
  } else if (confirmPassword.trim() != password.trim()) {
    return ErrorTexts.invalidConfirmPassword;
  }

  return '';
}

String validateVerifyCode({required String verifyCode}) {
  if (verifyCode.isEmpty) {
    return ErrorTexts.emptyVerifyCode;
  } else if (!verifyCodeRegex.hasMatch(verifyCode.trim())) {
    return ErrorTexts.invalidVerifyCode;
  }

  return '';
}

class Validators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return Messages.dontLeaveItblank;
    }
    if (value.length > 20) {
      return Messages.nameCannotExceed20Characters; // Kiểm tra độ dài
    }
    return null; // Hợp lệ
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return Messages.dontLeaveItblank;
    }

    //RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return Messages.emailIsNotValid;
    }
    return null; // Hợp lệ
  }
}
