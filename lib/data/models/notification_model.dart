import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String userId;
  final bool isRead;
  final String postId;
  final Timestamp createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.userId,
    required this.isRead,
    required this.postId,
    required this.createdAt,
  });

  factory NotificationModel.fromDocument(DocumentSnapshot doc) {
    return NotificationModel(
      id: doc.id,
      title: doc['title'] ?? '',
      userId: doc['user_id'] ?? '',
      isRead: doc['isRead'] ?? false,
      postId: doc['postId'] ?? '',
      createdAt: doc['created_at'],
    );
  }
}
