import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/app/messages.dart';
import 'package:network/viewmodels/blocs/bloc_post_popular/post_popular_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_post_popular/post_popular_event.dart';
import 'package:network/viewmodels/blocs/bloc_post_popular/post_popular_state.dart';
import 'package:network/views/widgets/home_widget/item_post_social.dart';

class PostListPopular extends StatefulWidget {
  const PostListPopular({
    super.key,
  });
  @override
  _PostListPopularState createState() => _PostListPopularState();
}

class _PostListPopularState extends State<PostListPopular>
    with AutomaticKeepAliveClientMixin {
  late PostBlocPopular _postBloc;

  @override
  void initState() {
    super.initState();
    _postBloc = BlocProvider.of<PostBlocPopular>(context);
    _postBloc.add(FetchPostPopulars());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocBuilder<PostBlocPopular, PostPopularState>(
        builder: (context, state) {
          if (state is PostPopularLoading) {
            return Container();
          } else if (state is PostPopularLoaded) {
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification) {
                  if (scrollNotification.metrics.extentAfter < 200) {
                    _postBloc.add(LoadMorePostPopulars());
                  }
                }
                return true;
              },
              child: ListView.builder(
                itemCount: state.posts.length + 1,
                itemBuilder: (context, index) {
                  if (index < state.posts.length) {
                    final post = state.posts[index];
                    final user = state.userMap[post.userId];

                    return Container(
                        padding: const EdgeInsets.all(10),
                        child: ItemPostSocial(
                          postId: post.id!,
                          imageUser: user!.avatarUrl,
                          nameUser: user.userName,
                          drectionPost: post.description,
                          imagePost: post.imageUrl,
                          createdAt: post.createdAt,
                        ));
                  } else if (state.hasMore) {
                    return Container();
                  }
                  return null;
                },
              ),
            );
          } else if (state is PostPopularError) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: Text(Messages.noPostsAvailable));
          }
        },
      ),
    );
  }
}
