import 'package:flutter/material.dart';

// Đường dẫn đến các icon, bạn có thể thay đổi đường dẫn tùy thuộc vào nơi lưu icon
const String iconHomeGradient = 'assets/icons/home_gradient.png';
const String iconDiscover = 'assets/icons/discover.png';
const String iconHome = 'assets/icons/home.png';
const String iconActivity = 'assets/icons/activity.png';
const String iconProfile = 'assets/icons/profile.png';
const String iconSearch = 'assets/icons/search.png';
const String iconSend = 'assets/icons/send.png';
const String iconActivityGradient = 'assets/icons/activity_gradient.png';
const String iconProfileGradient = 'assets/icons/profile_gradient.png';
const String iconDiscoverGradient = 'assets/icons/discover_gradient.png';
const String iconSendGradient = 'assets/icons/send_gradient.png';
const String iconEye = 'assets/icons/eye.png';
const String iconChat = 'assets/icons/chat.png';
const String iconBack = 'assets/icons/back.png';
const String iconAdd = 'assets/icons/add.png';
const String iconAddGradient = 'assets/icons/add_gradient.png';
const String iconAvatarDefault = 'assets/images/default_avatar.png';
const String iconCommentGradient = 'assets/icons/comment_gradient.png';
const String iconEyeGradient = 'assets/icons/eye_gradient.png';
const String iconHeartGradient = 'assets/icons/heart_gradient.png';
const String iconHeart = 'assets/icons/heart.png';

// Widget const để gọi lại icon, dễ dàng sử dụng trong UI
class IconWidget {
  static const Widget home = IconAsset(iconHome);
  static const Widget discover = IconAsset(iconDiscover);
  static const Widget activity = IconAsset(iconActivity);
  static const Widget profile = IconAsset(iconProfile);
  static const Widget search = IconAsset(iconSearch);
  static const Widget send = IconAsset(iconSend);
  static const Widget sendGradient = IconAsset(iconSendGradient);
  static const Widget homeGradient = IconAsset(iconHomeGradient);
  static const Widget activityGradient = IconAsset(iconActivityGradient);
  static const Widget profileGradient = IconAsset(iconProfileGradient);
  static const Widget discoverGradient = IconAsset(iconDiscoverGradient);
  static const Widget heart = IconAsset(iconHeart);
  static const Widget heartGradient = IconAsset(iconHeartGradient);
  static const Widget eye = IconAsset(iconEye);
  static const Widget chat = IconAsset(iconChat);
  static const Widget back = IconAsset(iconBack);
  static const Widget add = IconAsset(iconAdd);
  static const Widget addGradient = IconAsset(iconAddGradient);
  static const Widget defaultAvatar = IconAsset(iconAvatarDefault);
  static const Widget eyeGradient = IconAsset(iconEyeGradient);
  static const Widget commentGradient = IconAsset(iconCommentGradient);
}

// Widget để hiển thị icon từ asset
class IconAsset extends StatelessWidget {
  final String iconPath;

  const IconAsset(this.iconPath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      iconPath,
      width: 24, // Có thể tùy chỉnh kích thước icon tại đây
      height: 24,
    );
  }
}
