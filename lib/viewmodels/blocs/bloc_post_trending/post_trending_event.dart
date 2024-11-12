import 'package:equatable/equatable.dart';

abstract class PostTrendingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPostTrendings extends PostTrendingEvent {}

class LoadMorePostTrendings extends PostTrendingEvent {}

class RefreshPostTrendings extends PostTrendingEvent {}
