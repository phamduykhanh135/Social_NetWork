import 'package:equatable/equatable.dart';

abstract class PostPopularEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPostPopulars extends PostPopularEvent {}

class LoadMorePostPopulars extends PostPopularEvent {}

class RefreshPostPopulars extends PostPopularEvent {}
