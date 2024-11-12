import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/data/services/post_service.dart';
import 'package:network/data/services/user_service.dart';
import 'package:network/viewmodels/blocs/bloc_post_following/post_following_event.dart';
import 'package:network/viewmodels/blocs/bloc_post_following/post_following_state.dart';

class PostBlocFollowing extends Bloc<PostFollowingEvent, PostFollowingState> {
  PostService postService = PostService();
  UserService userService = UserService();
  static const int _limit = 20;
  // DocumentSnapshot? _lastDocument;

  PostBlocFollowing() : super(PostFollowingInitial()) {
    on<FetchPostFollowings>(_onFetchPosts);
    on<LoadMorePostFollowings>(_onLoadMorePosts);
    on<RefreshPostFollowings>(_onRefreshPosts);
  }

  Future<void> _onFetchPosts(
      FetchPostFollowings event, Emitter<PostFollowingState> emit) async {
    emit(PostFollowingLoading());
    try {
      final posts = await postService.fetchPostsForFollowings();
      // Lấy user cho các bài đăng vừa tải
      final userMap = await userService.fetchUsersForPosts(posts);
      emit(PostFollowingLoaded(
          posts: posts, userMap: userMap, hasMore: posts.length == _limit));
    } catch (e) {
      emit(PostFollowingError(error: e.toString()));
    }
  }

  Future<void> _onLoadMorePosts(
      LoadMorePostFollowings event, Emitter<PostFollowingState> emit) async {
    if (state is PostFollowingLoaded) {
      final currentState = state as PostFollowingLoaded;
      try {
        final posts = await postService.fetchPostsForFollowings();
        // Lấy user cho các bài đăng mới tải
        final userMap = await userService.fetchUsersForPosts(posts);

        emit(PostFollowingLoaded(
          posts: currentState.posts + posts,
          userMap: {...currentState.userMap, ...userMap},
          hasMore: posts.length == _limit,
        ));
      } catch (e) {
        emit(PostFollowingError(error: e.toString()));
      }
    }
  }

  Future<void> _onRefreshPosts(
      RefreshPostFollowings event, Emitter<PostFollowingState> emit) async {
    postService.resetPaginationPost();
    add(FetchPostFollowings());
  }
}
