import 'package:network/data/models/user_model.dart';

abstract class SearchState {}

class PostUsersInitial extends SearchState {}

class UserLoading extends SearchState {}

class UsersFound extends SearchState {
  final List<UserModel> users;

  UsersFound(this.users);
}

class UserLoaded extends SearchState {
  final UserModel user;

  UserLoaded(this.user);
}

class UserError extends SearchState {
  final String error;

  UserError(this.error);
}
