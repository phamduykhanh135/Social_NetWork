import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:network/app/messages.dart';
import 'package:network/data/models/post_model.dart';
import 'package:network/data/services/post_service.dart';

class ItemCollectionUser extends StatelessWidget {
  final String title;
  final String titleId;

  const ItemCollectionUser({
    super.key,
    required this.title,
    required this.titleId,
  });

  @override
  Widget build(BuildContext context) {
    final PostService postService = PostService();

    return GestureDetector(
      onTap: () {
        context.push('/title/$titleId', extra: {'title': title});
      },
      child: Column(
        children: [
          SizedBox(
            height: 160,
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
                        .getPostIdsByTitle(titleId), // Lắng nghe postIds
                    builder: (context, postSnapshot) {
                      if (postSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (postSnapshot.hasError) {
                        return const Center(
                            child: Text(Messages.errorLoadingPosts));
                      } else if (postSnapshot.hasData) {
                        final postIds = postSnapshot.data!;
                        if (postIds.isNotEmpty) {
                          if (postIds.length == 1) {
                            return FutureBuilder<PostModel>(
                              future: postService.getPostById(postIds[0]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
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
                              future: postService
                                  .getPostsByIds(postIds.take(2).toList()),
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                        fit: BoxFit.fill,
                                        height: double.infinity,
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
                          title,
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
          ),
          Container(
            padding: const EdgeInsets.only(left: 5, top: 5),
            child: StreamBuilder<int>(
              stream: postService.getShotCount(titleId),
              builder: (context, shotSnapshot) {
                if (shotSnapshot.connectionState == ConnectionState.waiting) {
                  return const Text(Messages.loadingImage);
                } else if (shotSnapshot.hasError) {
                  return const Text(Messages.errorLoadingImage);
                } else if (shotSnapshot.hasData) {
                  final totalShots = shotSnapshot.data!;
                  return Row(
                    children: [
                      Text(
                        totalShots < 2
                            ? ' $totalShots shot'
                            : ' $totalShots shots',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Row(
                    children: [
                      Text(
                        '0 shot',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
