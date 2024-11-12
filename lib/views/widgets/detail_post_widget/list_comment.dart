import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/app/messages.dart';
import 'package:network/viewmodels/blocs/bloc_commnets/comments_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_commnets/comments_state.dart';

import 'item_comment.dart';

class ListCommnent extends StatefulWidget {
  const ListCommnent({super.key});

  @override
  State<ListCommnent> createState() => _ListCommnentState();
}

class _ListCommnentState extends State<ListCommnent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is CommentLoading) {
          return Container();
        } else if (state is CommentLoaded) {
          final comments = state.comments;
          final userMap = state.userMap;

          if (comments.isEmpty) {
            return Container();
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              final user = userMap[comment.userId];

              return ItemComment(
                imageUser: user?.avatarUrl ?? '',
                nameUser: user?.userName ?? '',
                message: comment.message,
                createdAt: comment.createdAt,
              );
            },
          );
        }
        return const Center(child: Text(Messages.loading));
      },
    );
  }
}
