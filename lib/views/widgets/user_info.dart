import 'package:flutter/material.dart';
import 'package:network/utils/time_util.dart';

class UserInfo extends StatefulWidget {
  final String userId;
  final String imageUrl;
  final DateTime createdAt;

  const UserInfo({
    super.key,
    required this.userId,
    required this.imageUrl,
    required this.createdAt,
  });

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Avatar with default fallback image
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[200],
            child: ClipOval(
              child: widget.imageUrl.isNotEmpty
                  ? Image(
                      image: NetworkImage(widget.imageUrl),
                      fit: BoxFit.cover,
                      width: 48,
                      height: 48,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to default avatar if image fails to load
                        return const Image(
                          image: AssetImage('assets/images/default_avatar.png'),
                          fit: BoxFit.cover,
                          width: 48,
                          height: 48,
                        );
                      },
                    )
                  : const Image(
                      image: AssetImage('assets/images/default_avatar.png'),
                      fit: BoxFit.cover,
                      width: 48,
                      height: 48,
                    ),
            ),
          ),
          const SizedBox(width: 16),

          // User name and post time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget
                      .userId, // You can replace this with the user's name if available
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  DateTimeUtils.timeAgo(widget.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
