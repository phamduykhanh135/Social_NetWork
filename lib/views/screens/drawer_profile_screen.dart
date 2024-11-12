import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/app/image_paths.dart';
import 'package:network/utils/get_user_id.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_event.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_event.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_event.dart';
import 'package:network/views/widgets/drawer_profile_widget/animated_user_profile.dart';
import 'package:network/views/widgets/drawer_profile_widget/header_profile.dart';
import 'package:network/views/widgets/drawer_profile_widget/social_media_list.dart';

class DrawerProfileScreen extends StatefulWidget {
  const DrawerProfileScreen({super.key});

  @override
  State<DrawerProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<DrawerProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerController;

  late Animation<double> _scaleAnimation;

  late Animation<Offset> _translateAnimation;

  bool _isDrawerOpen = false;

  // Vị trí bắt đầu khi kéo (drag) để mở/đóng drawer
  double _dragStartX = 0;
  String? userId = getUserId();
  @override
  void initState() {
    super.initState();

    context.read<PostBloc>().add(FetchPostUsers(userId!));
    context.read<TitleBloc>().add(FetchTitles(userId!));
    context.read<UserBloc>().add(FetchUserDataEvent(userId!));
    _drawerController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    // animation thay đổi kích thước
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.60).animate(
        CurvedAnimation(parent: _drawerController, curve: Curves.easeInOut));

    // Tạo animation dịch chuyển widget từ vị trí 0 đến vị trí 0.7 của trục x
    _translateAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.7, 0.0)).animate(
            CurvedAnimation(
                parent: _drawerController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  // mở drawer
  void _openDrawer() {
    _drawerController.forward(); // Chạy animation về phía trước (mở drawer)
    setState(
        () => _isDrawerOpen = true); // Cập nhật trạng thái là drawer đang mở
  }

  // đóng drawer
  void _closeDrawer() {
    _drawerController.reverse(); // Chạy animation ngược lại (đóng drawer)
    setState(
        () => _isDrawerOpen = false); // Cập nhật trạng thái là drawer đã đóng
  }

  // khi bắt đầu kéo (drag) trên màn hình
  void _onHorizontalDragStart(DragStartDetails details) {
    _dragStartX = details.globalPosition.dx; // Lưu vị trí x khi bắt đầu kéo
  }

  // gọi khi kéo ngang (drag) trên màn hình
  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    // Nếu kéo từ trái sang phải và drawer chưa mở, mở drawer
    if (details.globalPosition.dx > _dragStartX && !_isDrawerOpen) {
      _openDrawer();
    }
    // Nếu kéo từ phải sang trái và drawer đang mở, đóng drawer
    else if (details.globalPosition.dx < _dragStartX && _isDrawerOpen) {
      _closeDrawer();
    }
  }

  //khi nhấn vào màn hình, đóng drawer nếu đang mở
  void _onTapBody() {
    if (_isDrawerOpen) _closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagePaths.darkBackgroundPath),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 300), // Animation cho drawer
                  transform:
                      Matrix4.translationValues(_isDrawerOpen ? 0 : -200, 0, 0),
                  child: const HeaderProfile(), // Danh sách các nút mạng xã hội
                ),
                AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 300), // Animation cho drawer
                  transform: Matrix4.translationValues(
                      _isDrawerOpen ? -70 : -200, 0, 0),
                  child:
                      const SocialMediaList(), // Danh sách các nút mạng xã hội
                ),
              ],
            ),
          ),
          AnimatedPositionedWidget(
            drawerController: _drawerController,
            scaleAnimation: _scaleAnimation,
            translateAnimation: _translateAnimation,
            isDrawerOpen: _isDrawerOpen,
            isShadow: true,
            onHorizontalDragStart: _onHorizontalDragStart,
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onTapBody: _onTapBody,
          ),
          AnimatedPositionedWidget(
            drawerController: _drawerController,
            scaleAnimation: _scaleAnimation,
            translateAnimation: _translateAnimation,
            isDrawerOpen: _isDrawerOpen,
            isShadow: false,
            onHorizontalDragStart: _onHorizontalDragStart,
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onTapBody: _onTapBody,
          ),
        ],
      ),
    );
  }
}
