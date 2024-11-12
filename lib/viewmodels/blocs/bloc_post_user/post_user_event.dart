import 'package:network/data/models/post_model.dart';

abstract class PostUserEvent {}

class FetchPostUsers extends PostUserEvent {
  final String uid;

  FetchPostUsers(this.uid);
}

class AddPostUser extends PostUserEvent {
  final PostModel post;

  AddPostUser(this.post);
}
