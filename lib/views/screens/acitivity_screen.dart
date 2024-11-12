import 'package:flutter/material.dart';
import 'package:network/app/messages.dart';
import 'package:network/data/models/notification_model.dart';
import 'package:network/data/services/notification_service.dart';
import 'package:network/utils/get_user_id.dart';
import 'package:network/views/widgets/activity_widget/item_activity.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with AutomaticKeepAliveClientMixin {
  final NotificationService notificationService = NotificationService();
  String? userId = getUserId();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text(
              'Activity ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            StreamBuilder<int>(
              stream: notificationService.getUnreadNotificationCount(userId!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('(0)');
                return Text(
                  '(${snapshot.data})',
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                );
              },
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<List<NotificationModel>>(
          stream: notificationService.getNotificationsStream(userId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text(Messages.noMessagesFound);
            }

            List<NotificationModel> notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                NotificationModel notification = notifications[index];
                return GestureDetector(
                  onTap: () {
                    notificationService.markNotificationAsRead(
                        userId!, notification.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ItemActivity(notification: notification),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
