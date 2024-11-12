abstract class CommentEvent {}

class FetchComments extends CommentEvent {
  final String postId;

  FetchComments(this.postId);
}

class LoadMoreComments extends CommentEvent {
  final String postId;

  LoadMoreComments(this.postId);
}

class AddComment extends CommentEvent {
  final String postId;
  final String message;

  AddComment(this.postId, this.message);
}

class RefreshComments extends CommentEvent {
  final String postId;
  RefreshComments(this.postId);
}
