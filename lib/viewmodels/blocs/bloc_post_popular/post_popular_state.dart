// post_state.dart
import 'package:equatable/equatable.dart';
import 'package:network/data/models/post_model.dart';
import 'package:network/data/models/user_model.dart';

abstract class PostPopularState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostPopularInitial extends PostPopularState {}

class PostPopularLoading extends PostPopularState {}

class PostPopularLoaded extends PostPopularState {
  final List<PostModel> posts;
  final Map<String, UserModel> userMap;
  final bool hasMore;
  final bool isLoadingMore; // Add this field
  PostPopularLoaded({
    required this.posts,
    required this.userMap,
    required this.hasMore,
    required this.isLoadingMore,
  });

  @override
  List<Object?> get props => [posts, userMap, hasMore];
}

class PostPopularError extends PostPopularState {
  final String error;

  PostPopularError({required this.error});

  @override
  List<Object?> get props => [error];
}
