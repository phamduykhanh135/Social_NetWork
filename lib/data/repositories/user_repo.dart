// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:network/data/models/social_post_model.dart';
// import 'package:network/data/services/firebase_service.dart';

// class SocialPostRepository {
//   final FirebaseFirestore _firestore = locator<FirebaseFirestore>();

//   Future<SocialPost?> fetchSocialPostById(String postId) async {
//     try {
//       DocumentSnapshot doc =
//           await _firestore.collection('social_posts').doc(postId).get();
//       if (doc.exists) {
//         return SocialPost.fromFirestore(
//             doc.id, doc.data() as Map<String, dynamic>);
//       }
//       return null;
//     } catch (e) {
//       print("Error fetching social post: $e");
//       return null;
//     }
//   }
// }
