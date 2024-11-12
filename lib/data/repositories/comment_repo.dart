// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:network/data/models/comment_model.dart';
// import 'package:network/data/models/user_model.dart';

// class CommentRepo {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<QuerySnapshot> fetchComments(String postId,
//       {DocumentSnapshot? lastDocument}) {
//     Query query = _firestore
//         .collection('comment')
//         .doc(postId)
//         .collection('detail_comment')
//         .orderBy('created_at', descending: true)
//         .limit(5); // Giới hạn 20 bình luận

//     if (lastDocument != null) {
//       query = query.startAfterDocument(lastDocument);
//     }

//     return query.get();
//   }

//   // Thêm bình luận mới
//   // Future<void> addComment(String postId, String userId, String message) async {
//   //   await _firestore
//   //       .collection('comment')
//   //       .doc(postId)
//   //       .collection('detail_comment')
//   //       .add({
//   //     'user_id': userId,
//   //     'message': message,
//   //     'like': 0,
//   //     'created_at': FieldValue.serverTimestamp(),
//   //   });
//   // }

//   // Lấy thông tin người dùng cho các bình luận
//   Future<Map<String, UserModel>> fetchUsersForComments(
//       List<CommentModel> comments) async {
//     final userIds = comments.map((comment) => comment.userId).toSet().toList();
//     final userMap = <String, UserModel>{};

//     if (userIds.isNotEmpty) {
//       try {
//         final userSnapshots = await _firestore
//             .collection('user')
//             .where(FieldPath.documentId, whereIn: userIds)
//             .get();

//         for (var userSnapshot in userSnapshots.docs) {
//           userMap[userSnapshot.id] = UserModel.fromDocument(userSnapshot);
//         }
//       } catch (e) {
//         print("Không thể lấy dữ liệu người dùng: ${e.toString()}");
//       }
//     }

//     return userMap;
//   }
// }
