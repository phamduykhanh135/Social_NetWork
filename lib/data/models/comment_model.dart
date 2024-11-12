// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String? id;
  final String userId;
  final int like;
  final String message;
  final dynamic createdAt; //datetime

  CommentModel({
    this.id,
    required this.userId,
    required this.like,
    required this.message,
    required this.createdAt,
  });

  factory CommentModel.fromDocument(DocumentSnapshot doc) {
    return CommentModel(
      id: doc.id,
      userId: doc['user_id'],
      message: doc['message'],
      like: doc['like'],
      createdAt: (doc['created_at'] as Timestamp).toDate(), // Proper conversion
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'message': message,
      'like': like,
      'created_at': createdAt,
    };
  }
}
