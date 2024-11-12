import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:network/app/messages.dart';
import 'package:network/data/models/post_model.dart';
import 'package:network/data/services/image_service.dart';
import 'package:network/utils/get_user_id.dart';

class PostService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ImageService imageStorageService = ImageService();
  String? userId = getUserId();
  static const int _limit = 20;
  DocumentSnapshot? _lastDocument;

  // Lấy post cho title
  Stream<List<PostModel>> fetchPostsFromTitle(String titleId) {
    return firestore
        .collection('collection_user')
        .doc(userId)
        .collection('titles')
        .doc(titleId)
        .snapshots()
        .asyncMap((titleDoc) async {
      List<dynamic> postIds = titleDoc['post'] ?? [];

      if (postIds.isNotEmpty) {
        QuerySnapshot postSnapshot = await firestore
            .collection('social_post')
            .where(FieldPath.documentId, whereIn: postIds)
            .get();

        List<PostModel> allPosts = postSnapshot.docs
            .map((doc) => PostModel.fromDocument(doc))
            .toList();

        return allPosts;
      }

      return [];
    });
  }

  // Lấy post all theo thời gian thực
  Stream<DocumentSnapshot<Map<String, dynamic>>> getPostStream(String postId) {
    return _firestore.collection('social_post').doc(postId).snapshots();
  }

  // Lấy post theo ID
  Future<PostModel> getPostById(String postId) async {
    DocumentSnapshot doc =
        await firestore.collection('social_post').doc(postId).get();
    return PostModel.fromDocument(doc); // Chuyển thành PostModel
  }

  // Lấy danh sách các post theo nhiều ID
  Future<List<PostModel>> getPostsByIds(List<String> postIds) async {
    if (postIds.isEmpty) return [];

    // Lấy tất cả các post theo danh sách ID
    QuerySnapshot querySnapshot = await firestore
        .collection('social_post')
        .where(FieldPath.documentId, whereIn: postIds)
        .get();

    return querySnapshot.docs
        .map((doc) => PostModel.fromDocument(doc))
        .toList(); // Chuyển tất cả thành PostModel
  }

  // Số lượng post rong title
  Stream<int> getShotCount(String titleId) {
    return firestore
        .collection('collection_user')
        .doc(userId)
        .collection('titles')
        .doc(titleId)
        .snapshots()
        .map((snapshot) {
      List<dynamic> postIds = snapshot['post'] ?? [];
      return postIds.length; // Trả về số lượng post
    });
  }

  //Lấy post trong title theo ID
  Stream<List<String>> getPostIdsByTitle(String titleId) {
    return firestore
        .collection('collection_user')
        .doc(userId)
        .collection('titles')
        .doc(titleId)
        .snapshots()
        .map((snapshot) {
      return List<String>.from(snapshot['post'] ?? []);
    });
  }

  Future<PostModel> createPost({
    required Uint8List imageBytes,
    required String description,
    required String hashtag,
  }) async {
    String imageURL = await imageStorageService.uploadImagePost(imageBytes);
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('social_post').doc();

    PostModel newPost = PostModel(
      id: postRef.id,
      userId: userId!,
      imageUrl: imageURL,
      description: description,
      hashtags: hashtag,
      createdAt: DateTime.now(),
      commentId: '',
    );

    await postRef.set(newPost.toMap());

    // Gửi thông báo đến người theo dõi sau khi tạo bài đăng
    await sendNotificationToFollowers(
      postRef.id,
      newPost.description,
    );
    return newPost; // Trả về một PostModel hoàn chỉnh
  }

  Future<void> sendNotificationToFollowers(
    String postId,
    String postTitle,
  ) async {
    // Lấy danh sách những người theo dõi userId
    QuerySnapshot followersSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('following')
        .get();

    // Tạo một danh sách các Future để lưu các thao tác gửi thông báo
    List<Future> notificationTasks = [];

    // Duyệt qua từng follower để tạo Future thêm thông báo
    for (var follower in followersSnapshot.docs) {
      String followerId = follower.id;

      // Thêm mỗi tác vụ gửi thông báo vào danh sách
      notificationTasks.add(
        FirebaseFirestore.instance
            .collection('notifications')
            .doc(followerId) // Document của mỗi người theo dõi
            .collection('user_notifications')
            .add({
          'created_at': Timestamp.now(),
          'isRead': false,
          'postId': postId,
          'title': postTitle,
          'user_id': userId,
        }),
      );
    }

    // Chờ tất cả các Future trong danh sách hoàn thành mà không chặn các tác vụ khác
    await Future.wait(notificationTasks);
  }

  Future<void> toggleReact(
      String postId, String userId, bool hasReacted) async {
    final postRef = _firestore.collection('social_post').doc(postId);
    final reactRef = postRef.collection('react_post').doc(userId);

    final userReaction = await reactRef.get();
    if (userReaction.exists) {
      // If the document exists, just update the status
      bool currentStatus = userReaction['status'] ?? false;
      await reactRef.update({'status': !currentStatus});
      await postRef
          .update({'likes': FieldValue.increment(currentStatus ? -1 : 1)});
    } else {
      // If the document doesn't exist, create a new document with status true
      await reactRef.set({
        'user_id': userId,
        'time': DateTime.now(),
        'status': true,
      });
      await postRef.update({'likes': FieldValue.increment(1)});
    }
  }

  // Hàm cập nhật lượt xem
  Future<void> incrementView(String postId) async {
    final postRef = _firestore.collection('social_post').doc(postId);
    await postRef.update({
      'views': FieldValue.increment(1),
    });
  }

  Stream<DocumentSnapshot> getUserLikeStatus(String postId, String userId) {
    return _firestore
        .collection('social_post')
        .doc(postId)
        .collection('likedBy')
        .doc(userId)
        .snapshots();
  }

  Future<void> toggleLike(String postId) async {
    final likedDoc = _firestore
        .collection('social_post')
        .doc(postId)
        .collection('likedBy')
        .doc(userId);

    final postRef = _firestore.collection('social_post').doc(postId);

    // Kiểm tra xem người dùng đã thích bài viết chưa
    final isLiked = (await likedDoc.get()).exists;

    if (isLiked) {
      // Nếu đã thích, xóa like của người dùng và giảm số lượng likes
      await likedDoc.delete();
      await postRef.update({
        'likes': FieldValue.increment(-1),
      });
    } else {
      // Nếu chưa thích, thêm like của người dùng và tăng số lượng likes
      await likedDoc.set({'likedAt': Timestamp.now()});
      await postRef.update({
        'likes': FieldValue.increment(1),
      });
    }
  }

  // Lấy các bài post từ những người dùng mà người dùng đang theo dõi
  Future<List<PostModel>> fetchPostsForFollowings() async {
    // Lấy danh sách userId mà người dùng đang theo dõi từ subcollection "following"
    final followingSnapshot = await _firestore
        .collection('user')
        .doc(userId)
        .collection('followers')
        .get();

    if (followingSnapshot.docs.isEmpty) {
      return []; // Nếu không theo dõi ai, trả về danh sách trống
    }

    // Lấy danh sách userId mà người dùng đang theo dõi
    final followingList = followingSnapshot.docs
        .map((doc) => doc.id) // Lấy userId từ document ID
        .toList();

    // Lấy các bài post từ các user trong danh sách "following"
    final query = _firestore
        .collection('social_post')
        .where('user_id', whereIn: followingList)
        .limit(_limit); // Bỏ sắp xếp theo likes

    QuerySnapshot querySnapshot;
    if (_lastDocument != null) {
      querySnapshot = await query.startAfterDocument(_lastDocument!).get();
    } else {
      querySnapshot = await query.get();
    }

    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
    }

    return querySnapshot.docs
        .map((doc) => PostModel.fromDocument(doc))
        .toList();
  }

  Future<List<PostModel>> fetchPostsForPopular() async {
    // Lấy danh sách "following" từ người dùng

    // Lấy danh sách userId mà người dùng đang theo dõi từ subcollection "following"
    final followingSnapshot = await _firestore
        .collection('user')
        .doc(userId)
        .collection('followers')
        .get();

    if (followingSnapshot.docs.isEmpty) {
      return []; // Nếu không theo dõi ai, trả về danh sách trống
    }

    // Lấy danh sách userId mà người dùng đang theo dõi
    final followingList = followingSnapshot.docs
        .map((doc) => doc.id) // Lấy userId từ document ID
        .toList();

    // Lấy các bài post từ các user trong danh sách "following"
    final query = _firestore
        .collection('social_post')
        .where('user_id', whereIn: followingList)
        .orderBy('likes', descending: true) // Sắp xếp theo số lượng likes
        .limit(_limit);

    QuerySnapshot querySnapshot;
    if (_lastDocument != null) {
      querySnapshot = await query.startAfterDocument(_lastDocument!).get();
    } else {
      querySnapshot = await query.get();
    }

    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
    }

    return querySnapshot.docs
        .map((doc) => PostModel.fromDocument(doc))
        .toList();
  }

  Future<List<PostModel>> fetchPostsForTrending() async {
    // Lấy ngày hiện tại và trừ đi 7 ngày để tạo ra giới hạn thời gian 7 ngày
    final DateTime sevenDaysAgo =
        DateTime.now().subtract(const Duration(days: 7));

    final query = _firestore
        .collection('social_post')
        .where('created_at', isGreaterThanOrEqualTo: sevenDaysAgo)
        .orderBy('created_at',
            descending: true) // Sắp xếp theo ngày tạo, mới nhất trước
        .orderBy('likes', descending: true) // Sau đó sắp xếp theo số lượt like
        .limit(_limit);

    QuerySnapshot querySnapshot;
    if (_lastDocument != null) {
      querySnapshot = await query.startAfterDocument(_lastDocument!).get();
    } else {
      querySnapshot = await query.get();
    }

    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
    }

    return querySnapshot.docs
        .map((doc) => PostModel.fromDocument(doc))
        .toList();
  }

// Lấy danh sách bài viết của người dùng theo userId
  Future<List<PostModel>> fetchPostsForUser(String uid) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('social_post')
          .where('user_id', isEqualTo: uid)
          .get();

      return snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception(Messages.postLoadError);
    }
  }

  // Thêm bài viết mới vào Firestore
  Future<void> addPost(PostModel post) async {
    try {
      await _firestore.collection('social_post').add(post.toMap());
    } catch (e) {
      throw Exception(Messages.errorAddingPost);
    }
  }

  void resetPaginationPost() {
    _lastDocument = null;
  }

  Future<PostModel> getPost(String postId) async {
    try {
      var postDoc = await FirebaseFirestore.instance
          .collection('social_post')
          .doc(postId)
          .get();

      if (postDoc.exists) {
        // Nếu document tồn tại, chuyển dữ liệu thành PostModel
        return PostModel.fromDocument(postDoc);
      } else {
        throw Exception(Messages.errorPostNotFound);
      }
    } catch (e) {
      throw Exception(Messages.postLoadError);
    }
  }
}
