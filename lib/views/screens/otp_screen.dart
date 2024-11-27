import 'dart:async';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:network/app/texts.dart';
import 'package:network/data/services/auth_service.dart';
import 'package:network/views/widgets/custom_elevated_button.dart';
import 'package:network/views/widgets/otp/opt_widget.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final AuthService _authService = AuthService();
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();
  late Timer _timer;
  int _countdown = 30;
  bool _isResendAvailable = false;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
    super.dispose();
  }

  Future<void> startCountdown() async {
    _isResendAvailable = false;
    _countdown = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _isResendAvailable = true;
          _timer.cancel();
        }
      });
    });
  }

  Future<void> resendOtp() async {
    await EmailOTP.sendOTP(email: widget.email);
    startCountdown();
  }

  Future<void> _handleSignUpOTP(BuildContext context) async {
    String enteredOtp = otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text;
    _authService.registerUserWithEmailAndOtp(
        context: context,
        email: widget.email,
        password: widget.password,
        otp: enteredOtp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          TitleTexts.eneterYourPinTitle,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.email,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OptWidget(otpController: otp1Controller),
                OptWidget(otpController: otp2Controller),
                OptWidget(otpController: otp3Controller),
                OptWidget(otpController: otp4Controller),
              ],
            ),
            const SizedBox(height: 80),
            Text(
              _isResendAvailable
                  ? TitleTexts.resendOTPCodeTitle
                  : "${TitleTexts.resendOtpLaterTitle} $_countdown ${TitleTexts.secondTitle}",
              style: const TextStyle(fontSize: 16),
            ),
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: _isResendAvailable ? Colors.blue : Colors.grey,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
              ),
              child: ElevatedButton(
                onPressed: _isResendAvailable
                    ? () {
                        resendOtp();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  TitleTexts.resendOTPCodeTitle,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 160,
            ),
            CustomElevatedButton(
                text: ButtonTexts.confirm,
                onPressed: () {
                  _handleSignUpOTP(context);
                })
          ],
        ),
      ),
    );
  }
}
