import 'package:flutter/material.dart';
import 'package:network/app/colors.dart';
import 'package:network/app/image_paths.dart';
import 'package:network/views/widgets/icon_widget.dart';

class AddCommentSection extends StatelessWidget {
  final TextEditingController commentController;
  final String? userAvatarUrl;
  final VoidCallback onCommentSubmitted;

  const AddCommentSection({
    super.key,
    required this.commentController,
    required this.userAvatarUrl,
    required this.onCommentSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: userAvatarUrl != null
                  ? NetworkImage(userAvatarUrl!)
                  : const AssetImage(
                      ImagePaths.defaultAvatarPath,
                    ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: commentController.text.isNotEmpty
                    ? [AppColor.primaryLight, AppColor.primaryDark]
                    : [AppColor.greyColor, AppColor.greyColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: IconWidget.send,
            ),
            onPressed: onCommentSubmitted,
          ),
        ],
      ),
    );
  }
}
