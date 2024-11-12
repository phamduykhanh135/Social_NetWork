import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/data/services/comment_service.dart';
import 'package:network/data/services/user_service.dart';
import 'package:network/viewmodels/blocs/bloc_commnets/comments_event.dart';
import 'package:network/viewmodels/blocs/bloc_commnets/comments_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentService commentService = CommentService();

  UserService userService = UserService();

  CommentBloc() : super(CommentInitial()) {
    on<FetchComments>(_onFetchComments);
    on<LoadMoreComments>(_onLoadMoreComments);
    on<AddComment>(_onAddComment);
    on<RefreshComments>(_onRefreshComments);
  }

  Future<void> _onRefreshComments(
      RefreshComments event, Emitter<CommentState> emit) async {
    commentService.resetPaginationComment();
    add(FetchComments(event.postId));
  }

  Future<void> _onFetchComments(
      FetchComments event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    commentService.resetPaginationComment();
    try {
      final comments = await commentService.fetchComments(event.postId);
      final userMap = await userService.fetchUsersForComments(comments);

      emit(CommentLoaded(comments: comments, userMap: userMap));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> _onLoadMoreComments(
      LoadMoreComments event, Emitter<CommentState> emit) async {
    if (state is CommentLoaded) {
      final currentState = state as CommentLoaded;
      try {
        final comments = await commentService.fetchComments(event.postId);
        final userMap = await userService.fetchUsersForComments(comments);

        emit(CommentLoaded(
          comments: currentState.comments + comments,
          userMap: {...currentState.userMap, ...userMap},
        ));
      } catch (e) {
        emit(CommentError(e.toString()));
      }
    }
  }

  Future<void> _onAddComment(
      AddComment event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    try {
      await commentService.addCommentToFirestore(event.postId, event.message);
      add(FetchComments(event.postId));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }
}
