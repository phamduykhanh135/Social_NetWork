
import 'package:equatable/equatable.dart';
import 'package:network/data/models/user_model.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoggedIn extends UserState {
  final String uid;

  const UserLoggedIn(this.uid);
}

class UserLoaded extends UserState {
  final UserModel user;

  const UserLoaded(this.user);
  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
