import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/data/services/post_service.dart';
import 'package:network/data/services/user_service.dart';
import 'package:network/viewmodels/blocs/bloc_post_popular/post_popular_event.dart';
import 'package:network/viewmodels/blocs/bloc_post_popular/post_popular_state.dart';

class PostBlocPopular extends Bloc<PostPopularEvent, PostPopularState> {
  PostService postService = PostService();
  UserService userService = UserService();
  static const int _limit = 20;

  PostBlocPopular() : super(PostPopularInitial()) {
    on<FetchPostPopulars>(_onFetchPosts);
    on<LoadMorePostPopulars>(_onLoadMorePosts);
    on<RefreshPostPopulars>(_onRefreshPosts);
  }

  Future<void> _onFetchPosts(
      FetchPostPopulars event, Emitter<PostPopularState> emit) async {
    emit(PostPopularLoading());
    try {
      final posts = await postService.fetchPostsForPopular();
      // Lấy user cho các bài đăng vừa tải
      final userMap = await userService.fetchUsersForPosts(posts);
      emit(PostPopularLoaded(
        posts: posts,
        userMap: userMap,
        hasMore: posts.length == _limit,
        isLoadingMore: false,
      )); // Chưa tải thêm nên mặc định là false
    } catch (e) {
      emit(PostPopularError(error: e.toString()));
    }
  }

  Future<void> _onLoadMorePosts(
      LoadMorePostPopulars event, Emitter<PostPopularState> emit) async {
    if (state is PostPopularLoaded) {
      final currentState = state as PostPopularLoaded;

      // Nếu đang tải thêm bài viết, không làm gì cả
      if (currentState.isLoadingMore) return;

      // Đánh dấu đang tải thêm
      emit(PostPopularLoaded(
        posts: currentState.posts,
        userMap: currentState.userMap,
        hasMore: currentState.hasMore,
        isLoadingMore: true, // Đang tải thêm
      ));

      try {
        final posts = await postService.fetchPostsForPopular();
        final userMap = await userService.fetchUsersForPosts(posts);

        emit(PostPopularLoaded(
          posts: currentState.posts + posts,
          userMap: {...currentState.userMap, ...userMap},
          hasMore: posts.length == _limit,
          isLoadingMore: false, // Tải xong thì set isLoadingMore về false
        ));
      } catch (e) {
        emit(PostPopularError(error: e.toString()));
      }
    }
  }

  // Future<void> _onLoadMorePosts(
  //     LoadMorePostPopulars event, Emitter<PostPopularState> emit) async {
  //   if (state is PostPopularLoaded) {
  //     final currentState = state as PostPopularLoaded;
  //     try {
  //       final posts = await postService.fetchPostsForPopular();
  //       // Lấy user cho các bài đăng mới tải
  //       final userMap = await userService.fetchUsersForPosts(posts);

  //       emit(PostPopularLoaded(
  //         posts: currentState.posts + posts,
  //         userMap: {...currentState.userMap, ...userMap},
  //         hasMore: posts.length == _limit, isLoadingMore: true, // Đang tải thêm
  //       ));
  //     } catch (e) {
  //       emit(PostPopularError(error: e.toString()));
  //     }
  //   }
  // }

  Future<void> _onRefreshPosts(
      RefreshPostPopulars event, Emitter<PostPopularState> emit) async {
    postService.resetPaginationPost();
    add(FetchPostPopulars());
  }
}
