import 'package:instapic/models/fetch_posts_status.dart';
import 'package:instapic/redux/actions/action_fetch_posts.dart';
import 'package:instapic/redux/actions/action_filters.dart';
import 'package:redux/redux.dart';

final reducersFetchStatus = combineReducers<PostsFetchStatus>([
  TypedReducer<PostsFetchStatus, ActionFetchPosts>(_reducerFetchPosts),
  TypedReducer<PostsFetchStatus, ActionFetchPostsSucceeded>(_reducerFetchPostsSucceeded),
  TypedReducer<PostsFetchStatus, ActionFetchPostsFailed>(_reducerFetchPostsFailed),
  TypedReducer<PostsFetchStatus, ActionUpdateFilters>(_reducerNewFilters),
]);

PostsFetchStatus _reducerFetchPosts(PostsFetchStatus status, ActionFetchPosts action) {
  return status.copyWith(isFetching: true);
}

PostsFetchStatus _reducerFetchPostsSucceeded(PostsFetchStatus status, ActionFetchPostsSucceeded action) {
  // print("_reducerFetchPostsSucceeded");
  return PostsFetchStatus(
    isFetching: false,
    nextStartIndex: status.nextStartIndex + action.posts.length,
    postsLoaded: status.postsLoaded + action.posts,
    postsNewlyArrived: action.posts
  );
}

PostsFetchStatus _reducerFetchPostsFailed(PostsFetchStatus status, ActionFetchPostsFailed action) {
  // print("_reducerFetchPostsFailed");
  return status.copyWith(isFetching: false, postsNewlyArrived: []);
}

PostsFetchStatus _reducerNewFilters(PostsFetchStatus status, ActionUpdateFilters action) {
  return PostsFetchStatus(isFetching: false, nextStartIndex: 0,postsLoaded: [], postsNewlyArrived: []);
}