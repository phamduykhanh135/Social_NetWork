import 'package:equatable/equatable.dart';
import 'package:network/data/models/post_model.dart';

import '../../../data/models/user_model.dart';

abstract class PostTrendingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostTrendingInitial extends PostTrendingState {}

class PostTrendingLoading extends PostTrendingState {}

class PostTrendingLoaded extends PostTrendingState {
  final List<PostModel> posts;
  final Map<String, UserModel> userMap;
  final bool hasMore;

  PostTrendingLoaded({
    required this.posts,
    required this.userMap,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [posts, userMap, hasMore];
}

class PostTrendingError extends PostTrendingState {
  final String error;

  PostTrendingError({required this.error});

  @override
  List<Object?> get props => [error];
}
