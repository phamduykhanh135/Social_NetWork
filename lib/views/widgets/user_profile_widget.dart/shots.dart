import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:network/app/image_paths.dart';
import 'package:network/app/messages.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_state.dart';
import 'package:network/views/widgets/user_profile_widget.dart/item_post.dart';

class Shots extends StatefulWidget {
  const Shots({super.key});

  @override
  State<Shots> createState() => _ShotsState();
}

class _ShotsState extends State<Shots> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostUserState>(builder: (context, state) {
      if (state is PostUsersLoading) {
        return Container();
      } else if (state is PostUsersLoaded) {
        final posts = state.post;
        if (posts.isEmpty) {
          return Center(
              child: Image.asset(
            ImagePaths.noShotPath,
            width: 300,
            height: 300,
          ));
        }
        return Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: MasonryGridView.builder(
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                String imageUrl = posts[index].imageUrl;
                return ItemPost(post: true, imageUrl: imageUrl);
              }),
        );
      }

      return const Center(child: Text(Messages.noPostsAvailable));
    });
  }
}
