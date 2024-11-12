import 'package:cloud_firestore/cloud_firestore.dart';

class Collection {
  String id;
  String titles;

  Collection({
    required this.id,
    required this.titles,
  });
  factory Collection.fromDocument(DocumentSnapshot doc) {
    return Collection(
      id: doc.id,
      titles: doc['titles'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titles': titles,
    };
  }
}
