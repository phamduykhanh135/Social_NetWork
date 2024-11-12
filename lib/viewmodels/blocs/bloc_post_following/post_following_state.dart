// post_state.dart
import 'package:equatable/equatable.dart';
import 'package:network/data/models/post_model.dart';
import 'package:network/data/models/user_model.dart';

abstract class PostFollowingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostFollowingInitial extends PostFollowingState {}

class PostFollowingLoading extends PostFollowingState {}

class PostFollowingLoaded extends PostFollowingState {
  final List<PostModel> posts;
  final Map<String, UserModel> userMap;
  final bool hasMore;

  PostFollowingLoaded(
      {required this.posts, required this.userMap, required this.hasMore});

  @override
  List<Object?> get props => [posts, userMap, hasMore];
}

class PostFollowingError extends PostFollowingState {
  final String error;

  PostFollowingError({required this.error});

  @override
  List<Object?> get props => [error];
}
