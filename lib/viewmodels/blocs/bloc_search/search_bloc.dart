import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/data/services/user_service.dart';
import 'package:network/utils/get_user_id.dart';
import 'package:network/viewmodels/blocs/bloc_search/search_event.dart';
import 'package:network/viewmodels/blocs/bloc_search/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final UserService _userService = UserService();

  String? userId = getUserId();

  SearchBloc() : super(PostUsersInitial()) {
    on<SearchFollowers>(onFetchSearchFollowers);
    on<SearchAll>(onFetchSearchAll);
  }

  Future<void> onFetchSearchFollowers(
      SearchFollowers event, Emitter<SearchState> emit) async {
    emit(UserLoading());

    try {
      final users = await _userService.searchFollowers(userId!, event.query);
      emit(UsersFound(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> onFetchSearchAll(
      SearchAll event, Emitter<SearchState> emit) async {
    emit(UserLoading());

    try {
      final users = await _userService.searchUsers(event.query);
      emit(UsersFound(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
