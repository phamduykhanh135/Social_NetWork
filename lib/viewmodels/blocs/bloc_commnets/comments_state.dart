import 'package:network/data/models/comment_model.dart';
import 'package:network/data/models/user_model.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<CommentModel> comments;
  final Map<String, UserModel> userMap; // Map userId to UserModel

  CommentLoaded({required this.comments, required this.userMap});
}

class CommentError extends CommentState {
  final String error;

  CommentError(this.error);
}
