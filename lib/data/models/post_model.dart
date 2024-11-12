import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? id;
  String userId;
  String imageUrl;
  String description;
  String hashtags;
  int likes;
  String commentId;
  int views;
  int commentTotal;
  DateTime createdAt;

  PostModel({
    this.id,
    required this.userId,
    required this.imageUrl,
    required this.description,
    required this.hashtags,
    this.likes = 0,
    required this.commentId,
    this.views = 0,
    this.commentTotal = 0,
    required this.createdAt,
  });

  // Chuyển từ Firestore DocumentSnapshot thành Post
  factory PostModel.fromDocument(DocumentSnapshot doc) {
    return PostModel(
      id: doc.id,
      userId: doc['user_id'] ?? '',
      imageUrl: doc['img_url'] ?? '',
      description: doc['description'] ?? '',
      hashtags: doc['hashtag'] ?? '',
      likes: (doc['likes'] ?? 0) is int
          ? doc['likes']
          : (doc['likes'] ?? 0).toInt(),
      views: (doc['views'] ?? 0) is int
          ? doc['views']
          : (doc['views'] ?? 0).toInt(),

      commentId: doc['commentId'] ?? '',
      commentTotal: (doc['comment_total'] ?? 0) is int
          ? doc['comment_total']
          : (doc['comment_total'] ?? 0).toInt(),

      createdAt: (doc['created_at'] as Timestamp).toDate(), // Proper conversion
    );
  }

  // Chuyển đổi Post thành Map để lưu trữ vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'img_url': imageUrl,
      'description': description,
      'hashtag': hashtags,
      'likes': likes,
      'commentId': commentId,
      'views': views,
      'comment_total': commentTotal,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}
