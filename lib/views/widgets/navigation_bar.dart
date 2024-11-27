import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/data/services/notification_service.dart';
import 'package:network/utils/get_user_id.dart';
import 'package:network/viewmodels/cubits/nav_cubit.dart';
import 'package:network/views/widgets/custom_icons.dart';
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
  final NotificationService notificationService = NotificationService();
  String? userId = getUserId();
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
              icon: CustomIcons.home(),
              index: 0,
              currentPageIndex: currentPageIndex,
              onTap: widget.onPageSelected,
              iconGradient: CustomIcons.homeBlue(),
            ),
            NavBarItemWidget(
              icon: CustomIcons.categogy(),
              index: 1,
              currentPageIndex: currentPageIndex,
              onTap: widget.onPageSelected,
              iconGradient: CustomIcons.categoryBlue(),
            ),
            const SizedBox(width: 48), // Chừa khoảng trống ở giữa cho FAB
            Stack(
              children: [
                Positioned(
                  child: NavBarItemWidget(
                    icon: CustomIcons.notification(),
                    index: 2,
                    currentPageIndex: currentPageIndex,
                    onTap: widget.onPageSelected,
                    iconGradient: CustomIcons.notificationBlue(),
                  ),
                ),
                Positioned(
                    top: 8,
                    right: 13,
                    child: StreamBuilder<int>(
                        stream: notificationService
                            .getUnreadNotificationCount(userId!),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data == 0) {
                            return const SizedBox.shrink();
                          }

                          return Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.red),
                            alignment: Alignment.center,
                            child: Text(
                              snapshot.data! > 99 ? '99+' : '${snapshot.data}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        })),
              ],
            ),

            NavBarItemWidget(
              icon: CustomIcons.profile(),
              index: 3,
              currentPageIndex: currentPageIndex,
              onTap: widget.onPageSelected,
              iconGradient: CustomIcons.profileBlue(),
            ),
          ],
        ),
      ),
    );
  }
}
