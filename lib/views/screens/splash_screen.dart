import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:network/app/colors.dart';
import 'package:network/app/image_paths.dart';
import 'package:network/app/texts.dart';
import 'package:network/utils/get_user_id.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  late Animation<double> _animation;
  // final bool _isAuthenticated = false; // Biến để lưu trữ trạng thái xác thực

  @override
  void initState() {
    super.initState();
    // Nếu ko bật xác thực email
    if (!_isUserLogin()) {
      _animationController = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      );
      _animation =
          Tween<double>(begin: 0, end: 1).animate(_animationController!);

      _animationController!.forward();
    } else {
      _goToHomeScreen(context);
    }
    // Nếu bật xác thực email
    // _animationController = AnimationController(
    //   duration: const Duration(seconds: 2),
    //   vsync: this,
    // );
    // _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!);

    // _checkIfUserIsAuthenticated().then((isAuthenticated) {
    //   setState(() {
    //     _isAuthenticated = isAuthenticated; // Cập nhật trạng thái xác thực
    //   });

    //   if (isAuthenticated) {
    //     _goToHomeScreen(context);
    //   } else {
    //     _animationController!.forward(); // Bắt đầu hoạt ảnh
    //   }
    // });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  // Nếu bật xác thực email
  // Future<bool> _checkIfUserIsAuthenticated() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   return user != null && user.emailVerified;
  // }

  // Nếu ko bật xác thực email
  bool _isUserLogin() {
    String? userId = getUserId();

    if (userId != null) {
      return true;
    }

    return false;
  }

  void _goToHomeScreen(BuildContext context) async {
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.pushReplacement('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            ImagePaths.darkBackgroundPath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            child: _isUserLogin()
                //_isAuthenticated // Kiểm tra trạng thái xác thực
                ? Image.asset(ImagePaths.splashScreenPath)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ImagePaths.splashScreenPath),
                      SizedBox(
                        height: screenSize.height / 25,
                      ),
                      FadeTransition(
                        opacity: _animation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              TitleTexts.sloganTitle,
                              style: TextStyle(
                                fontSize: 14,
                                color: TextColor.textWhite,
                              ),
                            ),
                            SizedBox(
                              height: screenSize.height / 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    BackgroundColor.getStartedBackground,
                                foregroundColor: TextColor.textWhite,
                                fixedSize: Size(screenSize.width / 2, 52),
                              ),
                              onPressed: () {
                                context.go('/signin');
                              },
                              child: const Text(
                                ButtonTexts.getStarted,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
