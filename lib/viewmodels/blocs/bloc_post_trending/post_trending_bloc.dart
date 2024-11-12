import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/data/services/post_service.dart';
import 'package:network/data/services/user_service.dart';
import 'package:network/viewmodels/blocs/bloc_post_trending/post_trending_event.dart';
import 'package:network/viewmodels/blocs/bloc_post_trending/post_trending_state.dart';

class PostBlocTrending extends Bloc<PostTrendingEvent, PostTrendingState> {
  PostService postService = PostService();
  UserService userService = UserService();
  static const int _limit = 20;

  PostBlocTrending() : super(PostTrendingInitial()) {
    on<FetchPostTrendings>(_onFetchPosts);
    on<LoadMorePostTrendings>(_onLoadMorePosts);
    on<RefreshPostTrendings>(_onRefreshPosts);
  }

  Future<void> _onFetchPosts(
      FetchPostTrendings event, Emitter<PostTrendingState> emit) async {
    emit(PostTrendingLoading());
    try {
      final posts = await postService.fetchPostsForTrending();
      // Lấy user cho các bài đăng vừa tải
      final userMap = await userService.fetchUsersForPosts(posts);
      emit(PostTrendingLoaded(
          posts: posts, userMap: userMap, hasMore: posts.length == _limit));
    } catch (e) {
      emit(PostTrendingError(error: e.toString()));
    }
  }

  Future<void> _onLoadMorePosts(
      LoadMorePostTrendings event, Emitter<PostTrendingState> emit) async {
    if (state is PostTrendingLoaded) {
      final currentState = state as PostTrendingLoaded;
      try {
        final posts = await postService.fetchPostsForTrending();
        final userMap = await userService.fetchUsersForPosts(posts);

        emit(PostTrendingLoaded(
          posts: currentState.posts + posts,
          userMap: {...currentState.userMap, ...userMap},
          hasMore: posts.length == _limit,
        ));
      } catch (e) {
        emit(PostTrendingError(error: e.toString()));
      }
    }
  }

  Future<void> _onRefreshPosts(
      RefreshPostTrendings event, Emitter<PostTrendingState> emit) async {
    postService.resetPaginationPost();
    add(FetchPostTrendings());
  }
}
