abstract class Texts {}

class TitleTexts extends Texts {
  static const String verificationTitle = 'VERIFICATION';
  static const String sloganTitle = 'SHARE - INSPIRE - CONNECT';
  static const String setNewPasswordTitle = 'SET NEW PASSWORD';
  static const String selectCategoryTitle = 'Who are you?';
  static const String forgotPasswordTitle = 'TYPE YOUR EMAIL';
}

class ButtonTexts extends Texts {
  static const String dontReceiveCode = 'DON\'T RECEIVE THE CODE';
  static const String verify = 'VERIFY';
  static const String getStarted = 'GET STARTED';
  static const String signUp = 'SIGN UP';
  static const String signIn = 'SIGN IN';
  static const String forgotPassword = 'FORGOT PASSWORD';
  static const String logIn = 'LOG IN';
  static const String send = 'SEND';
  static const String exploreNow = 'EXPLORE NOW';
}

class HintTexts extends Texts {
  static const String verificationHint = 'Verification code';
  static const String emailHint = 'Email';
  static const String passwordHint = 'Password';
  static const String confirmPasswordHint = 'Confirm Password';
}

class DescriptionTexts extends Texts {
  static const String automaticOtpFill =
      'An OTP code will be automatically filled through your link.';
  static const String alreadyHaveAccount = 'Already have account?';
  static const String orLogInBy = 'OR LOG IN BY';
  static const String dontHaveAccount = 'Don\'t have account?';
  static const String typeNewPassword = 'Type your new password';
  static const String sendLinkReset =
      'We will send you a link to your email for reset your password';
}

class ErrorTexts extends Texts {
  static const String emptyEmail = 'Email cannot be empty';
  static const String invalidEmail = 'Please enter a valid email';
  static const String emptyPassword = 'Password cannot be empty';
  static const String invalidPassword =
      'Password must contain at least one capital letter, number and special character';
  static const String emptyConfirmPassword = 'Confirm password cannot be empty';
  static const String invalidConfirmPassword =
      'Confirm password does not match the password';
  static const String emptyVerifyCode = 'Verify code cannot be empty';
  static const String invalidVerifyCode = 'Please enter a valid verify code';
}
