
import 'package:equatable/equatable.dart';
import 'package:network/data/models/user_model.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object?> get props => [];
}

class LoginEvent extends UserEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

// Sự kiện lấy thông tin user
class FetchUserDataEvent extends UserEvent {
  final String uid;

  const FetchUserDataEvent(this.uid);

  @override
  List<Object?> get props => [uid];
}

class CheckUserLoginEvent extends UserEvent {} // Thêm sự kiện này

class EditUserEvent extends UserEvent {
  final UserModel updatedUser;

  const EditUserEvent(this.updatedUser);
}
