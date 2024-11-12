import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:network/app/messages.dart';
import 'package:network/data/models/user_model.dart';
import 'package:network/data/services/user_service.dart';
import 'package:network/views/widgets/show_snackbar.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserService userService = UserService();

  Future<void> registerUserWithEmailAndOtp({
    required BuildContext context,
    required String email,
    required String password,
    required String otp,
  }) async {
    String message = '';

    if (EmailOTP.verifyOTP(otp: otp)) {
      try {
        UserCredential credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        if (credential.user != null) {
          UserModel userModel = UserModel(
              id: credential.user!.uid,
              email: email.trim(),
              avatarUrl: '',
              fullName: '',
              userName: '',
              userNameNormalized: '');

          await userService.saveUserToFirestore(userModel);
        }
        if (context.mounted) {
          context.push('/home');
        }

        // context.push('/verify');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          message = Messages.accountExisted;
        } else {
          message = Messages.somethingWrong; // Thông báo lỗi chung
        }
      } catch (e) {
        // Xử lý lỗi khác
        message = Messages.somethingWrong;
      }

      // Hiển thị thông báo nếu có
      if (context.mounted && message.isNotEmpty) {
        showSnackBar(context, message: message);
      }
    } else {
      // Nếu OTP không hợp lệ
      if (context.mounted) {
        message = Messages.invalidOtp; // Thông báo lỗi OTP không hợp lệ
        showSnackBar(context, message: message);
      }
    }
  }

  Future<void> signUpUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      if (await EmailOTP.sendOTP(email: email)) {
        if (context.mounted) {
          showSnackBar(context, message: Messages.otpSentSuccessfully);
          context.push('/otp/$email', extra: password);
        }
      } else {
        if (context.mounted) {
          context.pop(context);
          showSnackBar(context, message: Messages.otpSendFailed);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, message: Messages.errorOccurred);
      }
    }
  }

  Future<User?> signInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String message = '';
    UserCredential? credential;

    try {
      credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kiểm tra trạng thái xác thực email
      // if (credential.user != null && credential.user!.emailVerified) {
      //   if (context.mounted) {
      //     context.push(
      //         '/home'); // Điều hướng trực tiếp mà không cần Future.delayed
      //   }
      // } else {
      //   // Nếu chưa xác thực, yêu cầu người dùng xác thực email
      //   message = 'Bạn cần xác thực email trước khi vào Home.';
      //   await FirebaseAuth.instance.signOut();
      // }

      //Nếu không cần xác thực email
      if (context.mounted) {
        context
            .push('/home'); // Điều hướng trực tiếp mà không cần Future.delayed
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = Messages.noUserFound;
      } else if (e.code == 'wrong-password') {
        message = Messages.wrongPassword;
      } else {
        message = Messages.somethingWrong;
      }
    } catch (e) {
      message = Messages.somethingWrong;
    }

    if (context.mounted && message.isNotEmpty) {
      showSnackBar(context, message: message);
    }

    return credential?.user;
  }

  Future<void> signOutUser({required BuildContext context}) async {
    String message = '';

    try {
      await _firebaseAuth.signOut();

      message = Messages.signOut;
    } catch (e) {
      message = Messages.somethingWrong;
    }

    if (context.mounted) {
      showSnackBar(context, message: message);

      if (message == Messages.signOut) {
        context.go('/signin');
      }
    }
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          '95857329626-2loo5kv69o5tooutbcs77nc0gga4q2la.apps.googleusercontent.com',
    );

    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        if (context.mounted) {
          showSnackBar(context, message: Messages.cancelSignIn);
        }
        return null;
      } else {
        GoogleSignInAuthentication authentication =
            await account.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken,
        );
        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        return userCredential.user;
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, message: Messages.somethingWrong);
      }

      return null;
    }
  }

  //==> Đổi mật khẩu
  //Check mạng

  Future<void> changePassword(
      {required BuildContext context,
      required String currentPassword,
      required String newPassword}) async {
    User? user = _firebaseAuth.currentUser;
    try {
      // Tạo credential xác thực lại
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );

      // Xác thực lại và cập nhật mật khẩu mới
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      if (context.mounted) {
        showSnackBar(context, message: Messages.passwordChangedSuccessfully);
      }
    } on FirebaseAuthException catch (e) {
      if (e.message != null && e.message!.contains('network error')) {
        if (context.mounted) {
          showSnackBar(context, message: Messages.networkError);
        }
      } else {
        if (context.mounted) {
          showSnackBar(context, message: Messages.incorrectCurrentPassword);
        }
      }
    } catch (e) {
      {
        if (context.mounted) {
          showSnackBar(context, message: Messages.errorOccurred);
        }
      }
    }
  }

  //Xác thực email
  Future<void> sendVerificationEmail({required BuildContext context}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        if (context.mounted) {
          // Kiểm tra mounted trước khi sử dụng context
          showSnackBar(context, message: Messages.verificationEmailSent);
        }
      } else {
        if (context.mounted) {
          showSnackBar(context, message: Messages.emailVerified);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, message: Messages.emailVerificationSendFailed);
      }
    }
  }

  Future<bool> checkEmailVerified({required BuildContext context}) async {
    try {
      await _firebaseAuth.currentUser!.reload();
      return _firebaseAuth.currentUser!.emailVerified;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, message: Messages.emailVerificationCheckFailed);
      }
      return false;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
