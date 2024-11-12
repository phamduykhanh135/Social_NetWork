import 'package:network/data/models/post_model.dart';

abstract class PostUserState {}

class PostUsersInitial extends PostUserState {}

class PostUsersLoading extends PostUserState {}

class PostUsersLoaded extends PostUserState {
  final List<PostModel> post;

  PostUsersLoaded(this.post);
}

class PostUsersError extends PostUserState {
  final String message;

  PostUsersError(this.message);
}
