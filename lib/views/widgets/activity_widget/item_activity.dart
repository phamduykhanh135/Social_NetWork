import 'package:flutter/material.dart';
import 'package:network/app/messages.dart';
import 'package:network/data/models/notification_model.dart';
import 'package:network/data/models/post_model.dart';
import 'package:network/data/models/user_model.dart';
import 'package:network/data/services/post_service.dart';
import 'package:network/data/services/user_service.dart';
import 'package:network/utils/time_util.dart';

class ItemActivity extends StatefulWidget {
  final NotificationModel notification;

  const ItemActivity({super.key, required this.notification});

  @override
  State<ItemActivity> createState() => _ItemActivityState();
}

class _ItemActivityState extends State<ItemActivity> {
  PostService postService = PostService();
  UserService userService = UserService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        userService.getUser(widget.notification.userId),
        postService.getPost(widget.notification.postId),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        if (snapshot.hasError) {
          return const Center(child: Text(Messages.errorOccurred));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text(Messages.noDataAvailable));
        }

        UserModel user = snapshot.data![0];
        PostModel post = snapshot.data![1];

        return Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: widget.notification.isRead
                ? Colors.grey.shade100
                : const Color(0xFFF1F1FE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar user
              Container(
                width: 60,
                padding: const EdgeInsets.all(5),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: user.avatarUrl.isNotEmpty
                      ? NetworkImage(user.avatarUrl)
                      : const AssetImage('assets/images/default_avatar.png')
                          as ImageProvider,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.userName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${widget.notification.title} ${post.description}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      DateTimeUtils.timeAgo(
                          widget.notification.createdAt.toDate().toLocal()),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(5),
                width: 120,
                height: 80,
                child: Image.network(
                  post.imageUrl.isNotEmpty
                      ? post.imageUrl
                      : 'https://example.com/default_image.jpg',
                  width: 100,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
