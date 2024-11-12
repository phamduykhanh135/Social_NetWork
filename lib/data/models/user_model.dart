import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String? id; // Thêm trường uid
  late String email;
  late String fullName;
  late String userName;
  late String userNameNormalized;
  late String avatarUrl;
  late String? category;
  late int followersTotal;
  late int followingTotal;
  UserModel({
    required this.email,
    required this.avatarUrl,
    required this.fullName,
    required this.userName,
    required this.userNameNormalized,
    this.category,
    this.id, // Thêm uid vào constructor
    this.followersTotal = 0,
    this.followingTotal = 0,
  });
  factory UserModel.info() {
    return UserModel(
      email: '',
      avatarUrl: '',
      fullName: '',
      userName: '',
      userNameNormalized: '',
    );
  }
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      email: doc['email'] ?? '',
      avatarUrl: doc['avatar_url'] ?? '',
      fullName: doc['full_name'] ?? '',
      userName: doc['username'] ?? '',
      userNameNormalized: doc['username_normalized'] ?? '',
      category: doc['category'] ?? '',
      followersTotal: (doc['followers_total'] ?? 0) is int
          ? doc['followers_total']
          : (doc['followers_total'] ?? 0).toInt(),
      followingTotal: (doc['following_total'] ?? 0) is int
          ? doc['following_total']
          : (doc['following_total'] ?? 0).toInt(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'avatar_url': avatarUrl,
      'full_name': fullName,
      'email': email,
      'username': userName,
      'username_normalized': userNameNormalized,
      'category': category ?? '',
      'followers_total': followersTotal,
      'following_total': followingTotal
    };
  }
}
