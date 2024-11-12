import 'package:cloud_firestore/cloud_firestore.dart';

class TitleModel {
  final String? id;
  final String name;
  final List<String> post;

  TitleModel({
    this.id,
    required this.name,
    required this.post,
  });

  factory TitleModel.fromDocument(DocumentSnapshot doc) {
    return TitleModel(
      id: doc.id,
      name: doc['name'],
      post: List.from(doc['post'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'post': post,
    };
  }
}
