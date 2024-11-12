import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:network/data/services/title_service.dart';
import 'package:network/utils/get_user_id.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_event.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_state.dart';

class TitleBloc extends Bloc<TitleEvent, TitleState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TitleService _titleService = TitleService();

  String? userId = getUserId();

  TitleBloc() : super(TitleInitial()) {
    on<FetchTitles>(_onFetchTitlles);
    on<AddTitle>(_onAddTitle);
  }

  Future<void> _onFetchTitlles(
      FetchTitles event, Emitter<TitleState> emit) async {
    emit(TitlesLoading());
    try {
      final titles = await _titleService.fetchTitles(event.uid);
      emit(TitlesLoaded(titles));
    } catch (e) {
      emit(TitlesError(e.toString()));
    }
  }

  Future<void> _onAddTitle(AddTitle event, Emitter<TitleState> emit) async {
    emit(TitlesLoading());
    try {
      add(FetchTitles(userId!));
    } catch (e) {
      emit(TitlesError(e.toString()));
    }
  }
}
