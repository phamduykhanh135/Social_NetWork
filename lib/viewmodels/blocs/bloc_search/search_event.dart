abstract class SearchEvent {}

class SearchFollowers extends SearchEvent {
  final String query;

  SearchFollowers(this.query);
}

class SearchAll extends SearchEvent {
  final String query;

  SearchAll(this.query);
}

class FetchUserDetails extends SearchEvent {
  final String userId;

  FetchUserDetails(this.userId);
}
