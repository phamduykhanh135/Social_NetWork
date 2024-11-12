import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/app/routers.dart';
import 'package:network/firebase_options.dart';
import 'package:network/viewmodels/blocs/bloc_commnets/comments_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_post_following/post_following_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_post_trending/post_trending_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_post_popular/post_popular_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_search/search_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_bloc.dart';
import 'package:network/viewmodels/cubits/nav_cubit.dart';
import 'package:provider/provider.dart';

void main() async {
  EmailOTP.config(
    appName: 'Social Network',
    otpType: OTPType.numeric, // Hoặc OTPType.alpha, OTPType.alphaNumeric
    expiry: 30000, // Thời gian hết hạn của OTP (30 giây)
    appEmail: 'your_email@example.com',
    otpLength: 4, // Độ dài OTP
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Khởi tạo Firebase
  // FirebaseApp app =
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // setupLocator(app);

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 3),
  ));

  runApp(
    MultiProvider(
      providers: [
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider(
          create: (context) => UserBloc(),
        ),
        BlocProvider(create: (context) => PostBloc()),
        BlocProvider(
          create: (context) => TitleBloc(),
        ),
        BlocProvider<PostBlocPopular>(
          create: (context) => PostBlocPopular(),
        ),
        BlocProvider<PostBlocTrending>(
          create: (context) => PostBlocTrending(),
        ),
        BlocProvider<PostBlocFollowing>(
          create: (context) => PostBlocFollowing(),
        ),
        BlocProvider<CommentBloc>(
          create: (context) => CommentBloc(),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
