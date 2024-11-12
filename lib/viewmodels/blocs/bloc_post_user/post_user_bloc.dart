import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/data/models/post_model.dart';
import 'package:network/data/services/post_service.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_event.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_state.dart';

class PostBloc extends Bloc<PostUserEvent, PostUserState> {
  final PostService _postService = PostService();
  PostBloc() : super(PostUsersInitial()) {
    on<FetchPostUsers>(_onFetchPosts);
    on<AddPostUser>(_onAddPost);
  }

  Future<void> _onFetchPosts(
      FetchPostUsers event, Emitter<PostUserState> emit) async {
    emit(PostUsersLoading());
    try {
      List<PostModel> posts = await _postService.fetchPostsForUser(event.uid);

      emit(PostUsersLoaded(posts));
    } catch (e) {
      emit(PostUsersError(e.toString()));
    }
  }

  Future<void> _onAddPost(
      AddPostUser event, Emitter<PostUserState> emit) async {
    try {
      List<PostModel> posts =
          await _postService.fetchPostsForUser(event.post.userId);
      emit(PostUsersLoaded(posts));
    } catch (e) {
      emit(PostUsersError(e.toString()));
    }
  }
}
