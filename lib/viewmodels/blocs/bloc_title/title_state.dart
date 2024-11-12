
import 'package:network/data/models/titlle_model.dart';

abstract class TitleState {}

class TitleInitial extends TitleState {}

class TitlesLoading extends TitleState {}

class TitlesLoaded extends TitleState {
  final List<TitleModel> titles;

  TitlesLoaded(this.titles);
}

class TitlesError extends TitleState {
  final String errorMessage;

  TitlesError(this.errorMessage);
}
