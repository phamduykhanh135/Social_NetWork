import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:network/app/icon_paths.dart';

class CustomIcons {
  static SvgPicture facebook({double size = 24}) {
    return icon(IconPaths.facebookIconPath, size: size);
  }

  static SvgPicture facebookBlue({double size = 24}) {
    return icon(IconPaths.facebookBlueIconPath, size: size);
  }

  static SvgPicture instagram({double size = 24}) {
    return icon(IconPaths.instagramIconPath, size: size);
  }

  static SvgPicture globe({double size = 24}) {
    return icon(IconPaths.globeIconPath, size: size);
  }

  static SvgPicture ellipse({double size = 24}) {
    return icon(IconPaths.ellipseBIconPath, size: size);
  }

  static SvgPicture arrowRight({double size = 24}) {
    return icon(IconPaths.arrowRightIconPath, size: size);
  }

  static SvgPicture arrowBack({double size = 24}) {
    return icon(IconPaths.arrowBackIconPath, size: size);
  }

  static SvgPicture arrowLeft({double size = 24}) {
    return icon(IconPaths.arrowLeftIconPath, size: size);
  }

  static SvgPicture cancel({double size = 24}) {
    return icon(IconPaths.cancelIconPath, size: size);
  }

  static SvgPicture logOut({double size = 24}) {
    return icon(IconPaths.logOutIconPath, size: size);
  }

  static SvgPicture gridView({double size = 24}) {
    return icon(IconPaths.gridViewIconPath, size: size);
  }

  static SvgPicture image({double size = 24}) {
    return icon(IconPaths.imageIconPath, size: size);
  }

  static SvgPicture home({double size = 24}) {
    return icon(IconPaths.homeIconPath, size: size);
  }

  static SvgPicture camera({double size = 24}) {
    return icon(IconPaths.cameraIconPath, size: size);
  }

  static SvgPicture cameraBlue({double size = 24}) {
    return icon(IconPaths.cameraBlueIconPath, size: size);
  }

  static SvgPicture search({double size = 24}) {
    return icon(IconPaths.searchIconPath, size: size);
  }

  static SvgPicture searchBlue({double size = 24}) {
    return icon(IconPaths.searchBlueIconPath, size: size);
  }

  static SvgPicture profile({double size = 24}) {
    return icon(IconPaths.profileIconPath, size: size);
  }

  static SvgPicture profileBlue({double size = 24}) {
    return icon(IconPaths.profileBlueIconPath, size: size);
  }

  static SvgPicture send({double size = 24}) {
    return icon(IconPaths.sendIconPath, size: size);
  }

  static SvgPicture chatBlue({double size = 24}) {
    return icon(IconPaths.chatBlueIconPath, size: size);
  }

  static SvgPicture notification({double size = 24}) {
    return icon(IconPaths.notificationIconPath, size: size);
  }

  static SvgPicture addBlue({double size = 24}) {
    return icon(IconPaths.addBlueIconPath, size: size);
  }

  static SvgPicture heartBlue({double size = 24}) {
    return icon(IconPaths.heartBlueIconPath, size: size);
  }

  static SvgPicture heartBlues({double size = 24}) {
    return icon(IconPaths.heartBluesIconPath, size: size);
  }

  static SvgPicture upload({double size = 24}) {
    return icon(IconPaths.uploadIconPath, size: size);
  }

  static SvgPicture settingWhite({
    double size = 24,
  }) {
    return icon(IconPaths.settingWhiteIconPath, size: size);
  }

  static SvgPicture settingBlack({
    double size = 24,
  }) {
    return icon(IconPaths.settingBlackIconPath, size: size);
  }

  static SvgPicture edit({double size = 24}) {
    return icon(IconPaths.editIconPath, size: size);
  }

  static SvgPicture delete({double size = 24}) {
    return icon(IconPaths.deleteIconPath, size: size);
  }

  static SvgPicture cancelBlue({double size = 24}) {
    return icon(IconPaths.cancelBlueIconPath, size: size);
  }

  static SvgPicture show({double size = 24}) {
    return icon(IconPaths.showIconPath, size: size);
  }

  static SvgPicture hide({double size = 24}) {
    return icon(IconPaths.hideIconPath, size: size);
  }

  static SvgPicture filter({double size = 24}) {
    return icon(IconPaths.filterIconPath, size: size);
  }

  static SvgPicture gridViewBlue({double size = 24}) {
    return icon(IconPaths.gridViewBlueIconPath, size: size);
  }

  static SvgPicture notificationBlue({double size = 24}) {
    return icon(IconPaths.notificationBlueIconPath, size: size);
  }

  static SvgPicture homeBlue({double size = 24}) {
    return icon(IconPaths.homeBlueIconPath, size: size);
  }

  static SvgPicture sendBlue({double size = 24}) {
    return icon(IconPaths.sendBlueIconPath, size: size);
  }

  static SvgPicture heart({double size = 24}) {
    return icon(IconPaths.heartIconPath, size: size);
  }

  static SvgPicture google({double size = 24}) {
    return icon(IconPaths.googleIconPath, size: size);
  }

  static SvgPicture eyeBlue({double size = 24}) {
    return icon(IconPaths.eyeBlueIconPath, size: size);
  }

  static SvgPicture categogy({double size = 24}) {
    return icon(IconPaths.categoryIconPath, size: size);
  }

  static SvgPicture categoryBlue({double size = 24}) {
    return icon(IconPaths.categoryBlueIconPath, size: size);
  }

  static SvgPicture icon(String iconPath, {double size = 24}) {
    return SvgPicture.asset(
      iconPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      placeholderBuilder: (BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
