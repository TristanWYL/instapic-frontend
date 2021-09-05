class QuerySortBy {
  final String value;
  const QuerySortBy._internal(this.value);

  static const QuerySortBy USER = const QuerySortBy._internal("user");
  static const QuerySortBy TIME = const QuerySortBy._internal("time");
  static const QuerySortBy NONE = const QuerySortBy._internal("none");
}

class QuerySortOrder {
  final String value;
  const QuerySortOrder._internal(this.value);

  static const QuerySortOrder ASCENDING = const QuerySortOrder._internal("asc");
  static const QuerySortOrder DESCENDING =
      const QuerySortOrder._internal("des");
}

class Filters {
  final String? username;
  final QuerySortBy sortby;
  QuerySortOrder? order;

  Filters({
    this.username,
    this.sortby = QuerySortBy.NONE,
    this.order = QuerySortOrder.ASCENDING,
  }) {
    assert(!(username != null && sortby.value == QuerySortBy.USER.value),
        "When fetching posts of a specific user, sorting is not supported!");
    if (this.sortby == QuerySortBy.NONE) {
      this.order = null;
    }
  }

  @override
  int get hashCode =>
      username.hashCode ^
      sortby.hashCode ^
      order.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Filters &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          sortby.value == other.sortby.value &&
          order?.value == other.order?.value;
}
