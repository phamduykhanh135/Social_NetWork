import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:network/data/models/comment_model.dart';
import 'package:network/utils/get_user_id.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userId = getUserId();

  static const int _limit = 20;

  DocumentSnapshot? _lastDocument;
  Future<List<CommentModel>> fetchComments(String postId) async {
    final query = _firestore
        .collection('comment')
        .doc(postId)
        .collection('detail_comment')
        .orderBy('created_at', descending: true)
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
        .map((doc) => CommentModel.fromDocument(doc))
        .toList();
  }

  // reset lại commment
  void resetPaginationComment() {
    _lastDocument = null;
  }

  Future<void> addCommentToFirestore(String postId, String message) async {
    final comment = CommentModel(
      userId: userId!,
      message: message,
      like: 0,
      createdAt: FieldValue.serverTimestamp(), // Sử dụng thời gian từ server
    );

    await _firestore
        .collection('comment')
        .doc(postId)
        .collection('detail_comment')
        .add(comment.toMap());

    // Tăng số lượng bình luận của bài đăng
    final postRef = _firestore.collection('social_post').doc(postId);
    await postRef.update({
      'comment_total': FieldValue.increment(1),
    });
  }
}
