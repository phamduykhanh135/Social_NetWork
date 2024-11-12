import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/app/messages.dart';
import 'package:network/viewmodels/blocs/bloc_post_following/post_following_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_post_following/post_following_event.dart';
import 'package:network/viewmodels/blocs/bloc_post_following/post_following_state.dart';
import 'package:network/views/widgets/home_widget/item_post_social.dart';

class PostListFollowing extends StatefulWidget {
  const PostListFollowing({super.key});
  @override
  _PostListFollowingState createState() => _PostListFollowingState();
}

class _PostListFollowingState extends State<PostListFollowing>
    with AutomaticKeepAliveClientMixin {
  late PostBlocFollowing _postBloc;

  @override
  void initState() {
    super.initState();

    _postBloc = BlocProvider.of<PostBlocFollowing>(context);
    _postBloc.add(FetchPostFollowings());
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
      body: BlocBuilder<PostBlocFollowing, PostFollowingState>(
        builder: (context, state) {
          if (state is PostFollowingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostFollowingLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                _postBloc.add(RefreshPostFollowings());
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification.metrics.extentAfter < 200) {
                    _postBloc.add(LoadMorePostFollowings());
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
              ),
            );
          } else if (state is PostFollowingError) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: Text(Messages.noPostsAvailable));
          }
        },
      ),
    );
  }
}
