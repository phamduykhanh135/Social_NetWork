import 'package:flutter/material.dart';
import 'package:network/app/messages.dart';
import 'package:network/data/models/post_model.dart';
import 'package:network/data/services/post_service.dart';

class ItemCollectionBottomSheet extends StatefulWidget {
  final String title;
  final String titleId;

  const ItemCollectionBottomSheet({
    super.key,
    required this.title,
    required this.titleId,
  });

  @override
  State<ItemCollectionBottomSheet> createState() =>
      _ItemCollectionBottomSheetState();
}

class _ItemCollectionBottomSheetState extends State<ItemCollectionBottomSheet>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final PostService postService = PostService();

    return SizedBox(
      height: 170,
      width: 170,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            StreamBuilder<List<String>>(
              stream: postService
                  .getPostIdsByTitle(widget.titleId), // Lắng nghe postIds
              builder: (context, postSnapshot) {
                if (postSnapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else if (postSnapshot.hasError) {
                  return const Center(child: Text(Messages.errorLoadingPosts));
                } else if (postSnapshot.hasData) {
                  final postIds = postSnapshot.data!;
                  if (postIds.isNotEmpty) {
                    if (postIds.length == 1) {
                      return FutureBuilder<PostModel>(
                        future: postService.getPostById(postIds[0]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text(Messages.errorLoadingPosts));
                          } else if (snapshot.hasData) {
                            final post = snapshot.data!;
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                post.imageUrl,
                                fit: BoxFit.fill,
                                height: double.infinity,
                                width: double.infinity,
                              ),
                            );
                          } else {
                            return const Center(
                                child: Text(Messages.noPostsAvailable));
                          }
                        },
                      );
                    } else if (postIds.length >= 2) {
                      return FutureBuilder<List<PostModel>>(
                        future:
                            postService.getPostsByIds(postIds.take(2).toList()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text(Messages.errorLoadingPosts));
                          } else if (snapshot.hasData) {
                            final posts = snapshot.data!;
                            final doubledPosts = [...posts, ...posts];

                            return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 2,
                              ),
                              itemCount: 4,
                              itemBuilder: (context, postIndex) {
                                final post = doubledPosts[postIndex];
                                return Image.network(
                                  post.imageUrl,
                                  fit: BoxFit.cover,
                                );
                              },
                            );
                          } else {
                            return const Center(
                                child: Text(Messages.noPostsAvailable));
                          }
                        },
                      );
                    }
                  }
                }
                // Nếu không có dữ liệu từ snapshot
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF888BF4),
                        Color(0xFF5151C6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                );
              },
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
