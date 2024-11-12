import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:network/data/models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<NotificationModel>> getNotificationsStream(String userId) {
    return _firestore
        .collection('notifications') // Collection thông báo
        .doc(userId) // Document cho userId
        .collection('user_notifications') // Subcollection user_notifications
        .orderBy('created_at', descending: true) // Sắp xếp theo thời gian tạo
        .snapshots() // Lấy dữ liệu theo thời gian thực
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NotificationModel.fromDocument(
            doc); // Chuyển từ DocumentSnapshot thành NotificationModel
      }).toList();
    });
  }

  Future<void> markNotificationAsRead(
      String userId, String notificationId) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(userId)
        .collection('user_notifications')
        .doc(notificationId)
        .set({'isRead': true}, SetOptions(merge: true));
  }

  Stream<int> getUnreadNotificationCount(String userId) {
    return FirebaseFirestore.instance
        .collection('notifications')
        .doc(userId)
        .collection('user_notifications')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
