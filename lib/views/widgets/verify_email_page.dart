import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:network/data/services/auth_service.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final AuthService _authService = AuthService();
  bool isEmailVerified = false;
  bool canResendEmail = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    checkInitialEmailVerification();
  }

  void checkInitialEmailVerification() async {
    isEmailVerified = await _authService.checkEmailVerified(context: context);
    if (!isEmailVerified) {
      _authService.sendVerificationEmail(context: context);
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future<void> checkEmailVerified() async {
    final verified = await _authService.checkEmailVerified(context: context);
    setState(() {
      isEmailVerified = verified;
    });

    if (verified) {
      timer?.cancel();
      if (mounted) {
        context.go('/home');
      }
    }
  }

  Future<void> resendVerificationEmail() async {
    setState(() => canResendEmail = false); // Tắt nút gửi lại
    await _authService.sendVerificationEmail(context: context);

    Timer(const Duration(seconds: 30), () {
      setState(() => canResendEmail = true);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác Thực Email'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'A verification email has been sent to your email address.',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          ElevatedButton.icon(
            onPressed: canResendEmail ? resendVerificationEmail : null,
            icon: const Icon(Icons.email, size: 32),
            label: const Text('Gửi lại Email', style: TextStyle(fontSize: 24)),
            style: ElevatedButton.styleFrom(
              backgroundColor: canResendEmail
                  ? Colors.blue
                  : Colors.grey, // Chọn màu xanh hoặc xám
            ),
          ),
          TextButton(
            onPressed: _authService.signOut,
            child: const Text(
              'Đăng xuất',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
