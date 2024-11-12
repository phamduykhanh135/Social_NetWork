import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:network/app/messages.dart';
import 'package:network/data/models/comment_model.dart';
import 'package:network/data/models/post_model.dart';
import 'package:network/data/models/user_model.dart';
import 'package:network/views/widgets/show_snackbar.dart';
import 'package:network/utils/get_user_id.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_event.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? userId = getUserId();

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.doc(userId).collection('user').limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> fetchUserIdByEmail(String? email) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('user')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
  }

  Future<void> setUserCategory(
    String category,
    String userId,
    BuildContext context,
  ) async {
    try {
      await _firestore
          .collection('user')
          .doc(userId)
          .update({'category': category});
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context,
          message: Messages.somethingWrong,
        );
      }
    }
  }

  Future<void> saveUserToFirestore(UserModel user) async {
    await _firestore.collection('user').doc(userId).set(user.toMap());
  }

  Future<void> editUser(
    String imageUrl,
    String email,
    String username,
    String fullName,
    BuildContext context,
  ) async {
    if (fullName.trim().isEmpty || username.trim().isEmpty) {
      showSnackBar(
        context,
        message: Messages.fullInformationRequired,
        snackbarBackgroundColor: Colors.red,
      );
      return;
    }
    if (userId == null) {
      showSnackBar(
        context,
        message: Messages.userIdDoesNotExist,
        snackbarBackgroundColor: Colors.red,
      );
      return;
    }
    try {
      UserModel updatedUser = UserModel(
        id: userId!,
        email: email,
        avatarUrl: imageUrl,
        fullName: fullName,
        userName: username,
        userNameNormalized: removeDiacritics(username.toLowerCase()),
      );

      if (context.mounted) {
        context.read<UserBloc>().add(EditUserEvent(updatedUser));
        showSnackBar(
          context,
          message: Messages.profileSavedSuccessfully,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context,
          message: Messages.somethingWrong,
        );
      }
    }
  }

  // Lấy user cho comment
  Future<Map<String, UserModel>> fetchUsersForComments(
      List<CommentModel> comments) async {
    final userIds = comments.map((comment) => comment.userId).toSet().toList();
    final userMap = <String, UserModel>{};

    for (String userId in userIds) {
      final userSnapshot =
          await _firestore.collection('user').doc(userId).get();
      if (userSnapshot.exists) {
        userMap[userId] = UserModel.fromDocument(userSnapshot);
      }
    }

    return userMap;
  }

  // Lấy thông tin người dùng cho các bài post
  Future<Map<String, UserModel>> fetchUsersForPosts(
      List<PostModel> posts) async {
    final userIds = posts.map((post) => post.userId).toSet().toList();
    final userMap = <String, UserModel>{};

    for (String userId in userIds) {
      final userSnapshot =
          await _firestore.collection('user').doc(userId).get();
      if (userSnapshot.exists) {
        userMap[userId] = UserModel.fromDocument(userSnapshot);
      }
    }

    return userMap;
  }

  // Hàm tìm kiếm người dùng dựa trên username_normalized
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      String normalizedQuery = removeDiacritics(query.toLowerCase());

      final querySnapshot = await _firestore
          .collection('user')
          .where('username_normalized', isGreaterThanOrEqualTo: normalizedQuery)
          .where('username_normalized',
              isLessThanOrEqualTo: '$normalizedQuery\uf8ff')
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromDocument(doc))
          .toList();
    } catch (e) {
      throw Exception(Messages.errorSearchingUser);
    }
  }

  // Hàm lấy danh sách người dùng mà user đang theo dõi
  Future<List<UserModel>> searchFollowers(String userId, String query) async {
    try {
      String normalizedQuery = removeDiacritics(query.toLowerCase());

      // Lấy danh sách người dùng mà userId đang theo dõi
      final followingSnapshot = await _firestore
          .collection('user')
          .doc(userId)
          .collection('followers')
          .get();

      if (followingSnapshot.docs.isEmpty) {
        return [];
      }

      final followingList =
          followingSnapshot.docs.map((doc) => doc.id).toList();

      final querySnapshot = await _firestore
          .collection('user')
          .where('username_normalized', isGreaterThanOrEqualTo: normalizedQuery)
          .where('username_normalized',
              isLessThanOrEqualTo: '$normalizedQuery\uf8ff')
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromDocument(doc))
          .where((user) => followingList.contains(user.id))
          .toList();
    } catch (e) {
      throw Exception(Messages.errorSearchingFollowers);
    }
  }

  // Hàm lấy thông tin người dùng
  Future<UserModel?> fetchUserData(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('user').doc(userId).get();
      if (userDoc.exists) {
        return UserModel.fromDocument(userDoc);
      }
      return null;
    } catch (e) {
      throw Exception(Messages.errorFetchingUserData);
    }
  }

  // Hàm kiểm tra người dùng có đang đăng nhập không
  Future<String?> checkUserLogin() async {
    try {
      String? userId = getUserId(); // Giả sử bạn có hàm getUserId() lấy userId
      return userId;
    } catch (e) {
      throw Exception(Messages.errorCheckingLogin);
    }
  }

  // Hàm cập nhật thông tin người dùng
  Future<UserModel?> updateUserData(
      String userId, UserModel updatedUser) async {
    try {
      await _firestore
          .collection('user')
          .doc(userId)
          .update(updatedUser.toMap());
      // Sau khi cập nhật, lấy lại thông tin người dùng
      return await fetchUserData(userId);
    } catch (e) {
      throw Exception(Messages.errorUpdatingUserData);
    }
  }

  // Fetch User from Firestore
  Future<UserModel> getUser(String userId) async {
    try {
      var userDoc =
          await FirebaseFirestore.instance.collection('user').doc(userId).get();

      if (userDoc.exists) {
        // Nếu document tồn tại, chuyển dữ liệu thành PostModel
        return UserModel.fromDocument(userDoc);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception(Messages.errorFetchingUser);
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(String userId) {
    return _firestore.collection('user').doc(userId).snapshots();
  }

  // Kiểm tra theo dõi theo thời gian thực
  Stream<bool> isFollowingStream(String currentUserId, String targetUserId) {
    return _firestore
        .collection('user')
        .doc(targetUserId)
        .collection('followers')
        .doc(currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }

  Future<void> followUser(String currentUserId, String targetUserId) async {
    try {
      // Sử dụng Firestore Transaction để đảm bảo các thao tác được thực hiện đồng bộ
      await _firestore.runTransaction((transaction) async {
        // Lấy reference của các document cần thao tác
        DocumentReference targetUserRef =
            _firestore.collection('user').doc(targetUserId);
        DocumentReference currentUserRef =
            _firestore.collection('user').doc(currentUserId);
        DocumentReference followerRef =
            targetUserRef.collection('followers').doc(currentUserId);
        DocumentReference followingRef =
            currentUserRef.collection('following').doc(targetUserId);

        // Thêm user hiện tại vào followers của user được follow
        transaction.set(followerRef,
            <String, dynamic>{}); // Sử dụng kiểu Map<String, dynamic> trống

        // Thêm user được follow vào following của user hiện tại
        transaction.set(followingRef,
            <String, dynamic>{}); // Sử dụng kiểu Map<String, dynamic> trống

        // Cập nhật tổng số followers và following
        transaction.update(targetUserRef, {
          'followers_total': FieldValue.increment(1),
        });
        transaction.update(currentUserRef, {
          'following_total': FieldValue.increment(1),
        });
      });
    } catch (e) {
      // Log lỗi nếu có
      print("Error while following: $e");
      throw Exception("Failed to follow user: $e");
    }
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    try {
      // Sử dụng Firestore Transaction để đảm bảo tất cả thao tác thành công cùng một lúc
      await _firestore.runTransaction((transaction) async {
        // Lấy reference của các document cần thao tác
        DocumentReference targetUserRef =
            _firestore.collection('user').doc(targetUserId);
        DocumentReference currentUserRef =
            _firestore.collection('user').doc(currentUserId);
        DocumentReference followerRef =
            targetUserRef.collection('followers').doc(currentUserId);
        DocumentReference followingRef =
            currentUserRef.collection('following').doc(targetUserId);

        // Xóa user hiện tại khỏi followers của user được unfollow
        transaction.delete(followerRef);
        transaction.update(targetUserRef, {
          'followers_total': FieldValue.increment(-1),
        });

        // Xóa user được unfollow khỏi following của user hiện tại
        transaction.delete(followingRef);
        transaction.update(currentUserRef, {
          'following_total': FieldValue.increment(-1),
        });
      });
    } catch (e) {
      // Log lỗi nếu có

      throw Exception("Failed to unfollow user: $e");
    }
  }
}
