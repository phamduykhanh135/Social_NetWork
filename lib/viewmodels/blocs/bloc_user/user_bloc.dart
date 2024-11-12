import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/app/messages.dart';
import 'package:network/data/models/user_model.dart';
import 'package:network/data/services/user_service.dart';

import 'package:network/viewmodels/blocs/bloc_user/user_event.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService _userService = UserService(); // Khởi tạo UserService

  UserBloc() : super(UserInitial()) {
    on<FetchUserDataEvent>(_onFetchUserData);
    on<CheckUserLoginEvent>(_onCheckUserLogin);
    on<EditUserEvent>(_onEditUser);
  }

  Future<void> _onCheckUserLogin(
      CheckUserLoginEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      String? userId = await _userService.checkUserLogin();
      if (userId == null) {
        emit(const UserError(Messages.errorFetchingUser));
      } else {
        emit(UserLoggedIn(userId));
        add(FetchUserDataEvent(userId)); // Fetch user data after login check
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onFetchUserData(
      FetchUserDataEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      UserModel? user = await _userService.fetchUserData(event.uid);
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(const UserError(Messages.userNotFound));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onEditUser(EditUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      UserModel? updatedUser = await _userService.updateUserData(
          event.updatedUser.id!, event.updatedUser);
      if (updatedUser != null) {
        emit(UserLoaded(updatedUser));
      } else {
        emit(const UserError(Messages.userNotFound));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
