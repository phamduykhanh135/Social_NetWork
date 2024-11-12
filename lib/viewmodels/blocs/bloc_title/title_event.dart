

import 'package:network/data/models/titlle_model.dart';

abstract class TitleEvent {}

class FetchTitles extends TitleEvent {
  final String uid;

  FetchTitles(this.uid);
}

class AddTitle extends TitleEvent {
  final TitleModel title; // Đối tượng title mới

  AddTitle(this.title);
}

class FetchPostFromTitles extends TitleEvent {
  final String uid;
  final String titleId;

  FetchPostFromTitles(this.uid, this.titleId);
}
