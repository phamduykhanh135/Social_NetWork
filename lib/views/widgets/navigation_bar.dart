
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/viewmodels/cubits/nav_cubit.dart';
import 'package:network/views/widgets/icon_widget.dart';
import 'package:network/views/widgets/navbar_item.dart';

class NavigationBarWidget extends StatefulWidget {
  final ValueChanged<int> onPageSelected;

  const NavigationBarWidget({
    super.key,
    required this.onPageSelected,
  });

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    final currentPageIndex =
        context.watch<NavigationCubit>().state; // Đặt trong build()

    return BottomAppBar(
      shape: const CircularNotchedRectangle(), // Tạo notch cho FAB
      notchMargin: 8.0, // Khoảng trống xung quanh FAB
      elevation: 5.0, // Tạo bóng cho BottomAppBar
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Cân đều các icon
          children: <Widget>[
            NavBarItemWidget(
              icon: IconWidget.home,
              index: 0,
              currentPageIndex: currentPageIndex,
              onTap: widget.onPageSelected,
              iconGradient: IconWidget.homeGradient,
            ),
            NavBarItemWidget(
              icon: IconWidget.discover,
              index: 1,
              currentPageIndex: currentPageIndex,
              onTap: widget.onPageSelected,
              iconGradient: IconWidget.discoverGradient,
            ),
            const SizedBox(width: 48), // Chừa khoảng trống ở giữa cho FAB
            NavBarItemWidget(
              icon: IconWidget.activity,
              index: 2,
              currentPageIndex: currentPageIndex,
              onTap: widget.onPageSelected,
              iconGradient: IconWidget.activityGradient,
            ),
            NavBarItemWidget(
              icon: IconWidget.profile,
              index: 3,
              currentPageIndex: currentPageIndex,
              onTap: widget.onPageSelected,
              iconGradient: IconWidget.profileGradient,
            ),
          ],
        ),
      ),
    );
  }
}
