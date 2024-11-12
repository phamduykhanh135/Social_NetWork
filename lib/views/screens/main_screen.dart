import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:network/viewmodels/cubits/nav_cubit.dart';
import 'package:network/views/screens/acitivity_screen.dart';
import 'package:network/views/screens/discover_screen.dart';
import 'package:network/views/screens/home_page_screen.dart';
import 'package:network/views/screens/drawer_profile_screen.dart';
import 'package:network/views/widgets/gradient_fab.dart';
import 'package:network/views/widgets/navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final homePageKey = GlobalKey<NavigatorState>();
  final discoverKey = GlobalKey<NavigatorState>();
  final activityKey = GlobalKey<NavigatorState>();
  final profileKey = GlobalKey<NavigatorState>();

  late final List<Widget> pages;

  @override
  void initState() {
    pages = [
      //   PostListScreen(key: homePageKey),
      HomePage(key: homePageKey),
      DiscoverScreen(key: discoverKey),
      ActivityScreen(key: activityKey),
      DrawerProfileScreen(key: profileKey),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentPageIndex) {
        return Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: IndexedStack(
            index: currentPageIndex, // Hiển thị màn hình hiện tại
            children: pages,
          ),
          floatingActionButton: GradientFAB(
            onPressed: () {
              context.push('/add_post');
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: NavigationBarWidget(
            onPageSelected: (index) {
              context.read<NavigationCubit>().setPage(index); // Cập nhật tab
            },
          ),
        );
      },
    );
  }
}
