import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initConfig() async {
    await _remoteConfig.fetchAndActivate();
  }

  List<Map<String, dynamic>> getCategory() {
    String categoryData = _remoteConfig.getString('category');
    List<Map<String, dynamic>> listCategory =
        List<Map<String, dynamic>>.from(jsonDecode(categoryData));

    return listCategory;
  }
}
