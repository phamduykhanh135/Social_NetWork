import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:network/app/image_paths.dart';
import 'package:network/app/messages.dart';
import 'package:network/app/texts.dart';
import 'package:network/data/models/post_model.dart';
import 'package:network/data/services/post_service.dart';
import 'package:network/utils/get_user_id.dart';
import 'package:network/views/widgets/user_profile_widget.dart/item_post.dart';

class TitleScreen extends StatefulWidget {
  final String titleId;

  final String title;
  const TitleScreen({super.key, required this.titleId, required this.title});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen>
    with AutomaticKeepAliveClientMixin {
  final PostService postService = PostService();

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
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(child: Container())
          ],
        ),
      ),
      body: StreamBuilder<List<PostModel>>(
        stream: postService.fetchPostsFromTitle(widget.titleId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return const Center(child: Text(Messages.errorOccurred));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Image.asset(ImagePaths.noShotPath));
          } else {
            final posts = snapshot.data!;
            return GridView.builder(
              itemCount: posts.length,
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                return ItemPostToTitle(
                  post: posts[index],
                  titleId: widget.titleId,
                  onPostDeleted: () => setState(() {}),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ItemPostToTitle extends StatefulWidget {
  final PostModel post;
  final String titleId;
  final VoidCallback? onPostDeleted;

  const ItemPostToTitle({
    super.key,
    required this.post,
    required this.titleId,
    this.onPostDeleted,
  });

  @override
  State<ItemPostToTitle> createState() => _ItemPostToTitleState();
}

class _ItemPostToTitleState extends State<ItemPostToTitle> {
  String? userId = getUserId();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.3),
              title: const Text('!',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
              content: const Text(
                DescriptionTexts.doYouWantToDeleteThisPhoto,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red, // Màu chữ
                    shadowColor: Colors.grey, // Màu bóng
                    elevation: 5, // Độ cao của bóng
                  ),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('collection_user')
                        .doc(userId)
                        .collection('titles')
                        .doc(widget.titleId)
                        .update({
                      'post': FieldValue.arrayRemove([widget.post.id]),
                    });
                    Navigator.of(context).pop();

                    if (widget.onPostDeleted != null)
                      widget.onPostDeleted!(); // Gọi callback
                  },
                  child: const Text(ButtonTexts.delete,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green, // Màu chữ
                    shadowColor: Colors.grey, // Màu bóng
                    elevation: 5, // Độ cao của bóng
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng dialog
                  },
                  child: const Text(ButtonTexts.cacel),
                ),
              ],
            );
          },
        );
      },
      child: ItemPost(post: false, imageUrl: widget.post.imageUrl),
    );
  }
}
