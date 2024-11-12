import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:network/app/messages.dart';
import 'package:network/data/models/post_model.dart';
import 'package:network/data/services/post_service.dart';
import 'package:network/utils/get_user_id.dart';
import 'package:network/viewmodels/blocs/bloc_commnets/comments_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_commnets/comments_event.dart';
import 'package:network/views/widgets/detail_post_widget/custom_comment_widget.dart';
import 'package:network/views/widgets/custom_icons.dart';
import 'package:network/views/widgets/detail_post_widget/list_comment.dart';

class DetailPostScreen extends StatefulWidget {
  final String imageUser;
  final String nameUser;
  final String drectionPost;
  final String imagePost;
  final String createdAt;
  final String postId;

  const DetailPostScreen({
    super.key,
    required this.imageUser,
    required this.nameUser,
    required this.drectionPost,
    required this.imagePost,
    required this.createdAt,
    required this.postId,
  });

  @override
  State<DetailPostScreen> createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen>
    with AutomaticKeepAliveClientMixin {
  late CommentBloc _commentBloc;
  final ScrollController _scrollController = ScrollController();

  //
  final PostService _postService = PostService();
  final ValueNotifier<bool> _isLikedNotifier =
      ValueNotifier<bool>(false); // Sử dụng ValueNotifier
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(false);
  String? userId = getUserId();

  @override
  void initState() {
    super.initState();
    _commentBloc = BlocProvider.of<CommentBloc>(context);
    _commentBloc.add(FetchComments(widget.postId));
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _commentBloc.add(LoadMoreComments(widget.postId));
      }
    });
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
  void dispose() {
    _isLoadingNotifier.dispose();
    _isLikedNotifier.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    expandedHeight: 120.0,
                    leading: IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: CustomIcons.arrowBack(size: 30),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(70.0),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(widget.imageUser),
                          ),
                          title: Text(widget.nameUser),
                          trailing: Text(
                            widget.createdAt,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image.network(
                            widget.imagePost,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                        ),
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: _postService.getPostStream(widget.postId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (!snapshot.hasData || snapshot.data == null) {
                              return const Center(
                                  child: Text(Messages.noDataAvailable));
                            }

                            final post = PostModel.fromDocument(
                                snapshot.data!); // Chuyển đổi từ snapshot

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Text('${post.views}'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      CustomIcons.eyeBlue(),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Row(
                                    children: [
                                      Text('${post.commentTotal}'),
                                      IconButton(
                                        onPressed: () {},
                                        icon: CustomIcons.chatBlue(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
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
                                                ? CustomIcons.heartBlues(
                                                    size: 20)
                                                : CustomIcons.heartBlue(),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, bottom: 10),
                          child: Text(widget.drectionPost),
                        ),
                        RefreshIndicator(
                            onRefresh: () async {
                              _commentBloc.add(RefreshComments(widget.postId));
                            },
                            child: const ListCommnent()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CustomCommentWidget(
              onCommentSubmitted: (comment) {
                _commentBloc.add(AddComment(widget.postId, comment));
              },
            ),
          ],
        ),
      ),
    );
  }
}
