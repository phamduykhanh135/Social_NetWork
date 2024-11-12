import 'package:go_router/go_router.dart';
import 'package:network/views/screens/change_password.dart';
import 'package:network/views/screens/otp_screen.dart';
import 'package:network/views/screens/search_screen.dart';
import 'package:network/views/screens/signin_screen.dart';
import 'package:network/views/screens/signup_screen.dart';
import 'package:network/views/widgets/verify_email_page.dart';
import 'package:network/views/screens/add_post_screen.dart';
import 'package:network/views/screens/edit_profile_screen.dart';
import 'package:network/views/screens/forgot_password_screen.dart';
import 'package:network/views/screens/main_screen.dart';
import 'package:network/views/screens/splash_screen.dart';
import 'package:network/views/screens/title_screen.dart';
import 'package:network/views/screens/user_search_screen.dart';
import 'package:network/views/widgets/home_widget/collection_bottom_sheet.dart';
import 'package:network/views/screens/detail_post_screen.dart';

GoRouter router = GoRouter(routes: <GoRoute>[
  GoRoute(
      path: '/',
      builder: (context, state) {
        return const SplashScreen();
      }),
  GoRoute(
      path: '/signin',
      builder: (context, state) {
        return const SignInScreen();
      }),
  GoRoute(
      path: '/signup',
      builder: (context, state) {
        return const SignUpScreen();
      }),
  GoRoute(
      path: '/home',
      builder: (context, state) {
        return const MainScreen();
      }),
  GoRoute(
      path: '/verify',
      builder: (context, state) {
        return const VerifyEmailPage();
      }),
  GoRoute(
      path: '/change_password',
      builder: (context, state) {
        return const ChangePasswordScreen();
      }),
  GoRoute(
      path: '/add_post',
      builder: (context, state) {
        return const AddPostScreen();
      }),
  GoRoute(
    path: '/edit_profile',
    builder: (context, state) => const EditProfileScreen(),
  ),
  GoRoute(
    path: '/add_collection',
    builder: (context, state) => const AddCollection(),
  ),
  GoRoute(
    path: '/forgot_password',
    builder: (context, state) {
      return const ForgotPasswordScreen();
    },
  ),
  GoRoute(
    path: '/otp/:email',
    builder: (context, state) {
      final email = state.pathParameters['email'];
      final password = state.extra as String?;

      return OtpScreen(
        email: email ?? '',
        password: password ?? '',
      );
    },
  ),
  GoRoute(
    path: '/title/:titleId',
    builder: (context, state) {
      final String titleId = state.pathParameters['titleId']!;
      final Map<String, dynamic>? extra =
          state.extra as Map<String, dynamic>?; // Lấy extra
      final String? title = extra?['title']; // Lấy title từ extra

      return TitleScreen(
        titleId: titleId,
        title: title ??
            'Default Title', // Sử dụng giá trị mặc định nếu title không có
      );
    },
  ),
  GoRoute(
    path: '/search',
    builder: (context, state) {
      return const SearchScreen();
    },
  ),
  GoRoute(
    path: '/user_search/:userId',
    builder: (context, state) {
      final String userId = state.pathParameters['userId']!;
      return UserSearchScreen(uid: userId);
    },
  ),
  GoRoute(
    path: '/detail_post/:post_id',
    builder: (context, state) {
      final String postId = state.pathParameters['post_id']!;
      final extraData = state.extra as Map<String, dynamic>?;
      final String imageUser = extraData?['image_user'] ?? '';
      final String nameUser = extraData?['name_user'] ?? '';
      final String drectionPost = extraData?['drection_post'] ?? '';
      final String imagePost = extraData?['image_post'] ?? '';

      // Chuyển đổi createdAt thành DateTime từ chuỗi
      final String createdAt = extraData?['created_at'] ?? '';

      return DetailPostScreen(
        postId: postId,
        imageUser: imageUser,
        nameUser: nameUser,
        drectionPost: drectionPost,
        imagePost: imagePost,
        createdAt: createdAt,
      );
    },
  )
]);
