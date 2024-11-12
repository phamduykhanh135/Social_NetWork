import 'package:equatable/equatable.dart';

abstract class PostFollowingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPostFollowings extends PostFollowingEvent {}

class LoadMorePostFollowings extends PostFollowingEvent {}

class RefreshPostFollowings extends PostFollowingEvent {}
