// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:network/app/image_paths.dart';
import 'package:network/app/messages.dart';
import 'package:network/data/models/post_model.dart';
import 'package:network/data/services/post_service.dart';
import 'package:network/utils/get_user_id.dart';
import 'package:network/utils/time_util.dart';
import 'package:network/views/widgets/home_widget/collection_bottom_sheet.dart';

import 'package:network/views/widgets/custom_icons.dart';

class ItemPostSocial extends StatefulWidget {
  final String imageUser;
  final String nameUser;
  final String drectionPost;
  final String imagePost;
  final String postId;
  final DateTime createdAt;

  const ItemPostSocial({
    super.key,
    required this.imageUser,
    required this.nameUser,
    required this.drectionPost,
    required this.imagePost,
    required this.postId,
    required this.createdAt,
  });

  @override
  State<ItemPostSocial> createState() => _ItemPostState();
}

class _ItemPostState extends State<ItemPostSocial> {
  final PostService _postService = PostService();
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(false);
  String? userId = getUserId();

  void _incrementView() {
    _postService.incrementView(widget.postId);
  }

  @override
  void initState() {
    super.initState();
  }

  void _toggleLike() async {
    if (userId != null && !_isLoadingNotifier.value) {
      _isLoadingNotifier.value = true;
      await _postService.toggleLike(
        widget.postId,
      );
      _isLoadingNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: widget.imageUser.isNotEmpty
                    ? NetworkImage(widget.imageUser)
                    : const AssetImage(ImagePaths.defaultAvatarPath),
              ),
              title: Text(widget.nameUser),
              trailing: Text(
                DateTimeUtils.timeAgo(widget.createdAt),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
                child: Text(
                  widget.drectionPost,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _incrementView();

                  context.push(
                    '/detail_post/${widget.postId}',
                    extra: {
                      'image_user': widget.imageUser,
                      'name_user': widget.nameUser,
                      'drection_post': widget.drectionPost,
                      'image_post': widget.imagePost,
                      'created_at': DateTimeUtils.timeAgo(widget.createdAt)
                    },
                  );
                },
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.network(
                    widget.imagePost,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                ),
              ),
            ],
          ),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: _postService.getPostStream(widget.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text(Messages.noData));
                }

                final post = PostModel.fromDocument(
                    snapshot.data!); // Chuyển đổi từ snapshot

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor:
                                  Colors.transparent, // Để trong suốt nền
                              isScrollControlled: true,
                              builder: (context) =>
                                  CollectionBottomSheet(idPost: widget.postId),
                            );
                          },
                          icon: CustomIcons.addBlue()),
                      Row(
                        children: [
                          Row(
                            children: [
                              Text('${post.commentTotal}'),
                              IconButton(
                                  onPressed: () {},
                                  icon: CustomIcons.chatBlue()),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          StreamBuilder<DocumentSnapshot>(
                            stream: _postService.getUserLikeStatus(
                                widget.postId, userId!),
                            builder: (context, likeSnapshot) {
                              final isLiked =
                                  likeSnapshot.data?.exists ?? false;

                              return Row(
                                children: [
                                  Text('${post.likes}'),
                                  IconButton(
                                    onPressed: _toggleLike,
                                    icon: isLiked
                                        ? CustomIcons.heartBlues(size: 20)
                                        : CustomIcons.heartBlue(),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }
}
