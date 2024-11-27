import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/app/messages.dart';
import 'package:network/viewmodels/blocs/bloc_post_trending/post_trending_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_post_trending/post_trending_event.dart';
import 'package:network/viewmodels/blocs/bloc_post_trending/post_trending_state.dart';
import 'package:network/views/widgets/home_widget/item_post_social.dart';

class PostListTrending extends StatefulWidget {
  const PostListTrending({super.key});
  @override
  _PostListTrendingState createState() => _PostListTrendingState();
}

class _PostListTrendingState extends State<PostListTrending>
    with AutomaticKeepAliveClientMixin {
  late PostBlocTrending _postBloc;

  @override
  void initState() {
    super.initState();

    _postBloc = BlocProvider.of<PostBlocTrending>(context);
    _postBloc.add(FetchPostTrendings());
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
      body: BlocBuilder<PostBlocTrending, PostTrendingState>(
        builder: (context, state) {
          if (state is PostTrendingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostTrendingLoaded) {
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification.metrics.extentAfter < 200) {
                  _postBloc.add(LoadMorePostTrendings());
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  _postBloc.add(RefreshPostTrendings());
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
                      return const SizedBox.shrink();
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            );
          } else if (state is PostTrendingError) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: Text(Messages.noPostsAvailable));
          }
        },
      ),
    );
  }
}
