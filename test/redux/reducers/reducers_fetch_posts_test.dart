import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/fetch_posts_status.dart';
import 'package:instapic/models/filters.dart';
import 'package:instapic/models/post.dart';
import 'package:instapic/redux/actions/action_fetch_posts.dart';
import 'package:instapic/redux/actions/action_filters.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:redux/redux.dart';

void main() {
  group("Reducers for Fetching Posts", () {
    test(
        "should change 'isFetching' of 'PostsFetchStatus' as 'true', and start a fetching action in response to an ActionFetchPosts",
        () {
      final store = Store<AppState>(appReducer, initialState: AppState());
      final action = ActionFetchPosts(filters: Filters());
      store.dispatch(action);
      expect(selectorIsFetchingPosts(selectorPostsStatus(store.state)), true);
    });

    test(
        "should 1) change 'isFetching' of 'PostsFetchStatus' as 'false', 2) update 'nextStartIndex' accordingly, 3) update 'postsNewlyArrived' with newly loaded posts, and 4) append the newly loaded posts to the end of 'postsLoaded' in response to an ActionFetchPostsSucceeded",
        () {
      final random = new Random();
      int nextStartIndex = random.nextInt(10000);
      final store = Store<AppState>(appReducer,
          initialState: AppState(
              postsFetchStatus: PostsFetchStatus(
                  isFetching: true,
                  nextStartIndex: nextStartIndex,
                  postsLoaded: [Post("username", "pictureUrl", "description", DateTime.now())],
                  postsNewlyArrived: [])));
      final newFetchedPosts = [
        Post("username1", "pictureUrl1", "description1", DateTime.now()),
        Post("username2", "pictureUrl2", "description2", DateTime.now()),
      ];
      final action = ActionFetchPostsSucceeded(newFetchedPosts);
      store.dispatch(action);
      expect(selectorIsFetchingPosts(selectorPostsStatus(store.state)), false);
      expect(selectorPostsStatus(store.state).nextStartIndex, nextStartIndex + newFetchedPosts.length);
      expect(selectorPostsStatus(store.state).postsNewlyArrived, newFetchedPosts);
      expect(selectorPostsStatus(store.state).postsLoaded.sublist(selectorPostsStatus(store.state).postsLoaded.length-newFetchedPosts.length), newFetchedPosts);
    });

    test(
        "should change 'isFetching' of 'PostsFetchStatus' as 'false', and the received posts are unchanged, in response to an ActionFetchPostsFailed",
        () {
      final postsLoaded = [
        Post("username", "pictureUrl", "description", DateTime.now())
      ];
      final postsNewlyArrived = [
        Post("username1", "pictureUrl1", "description1", DateTime.now())
      ];
      final store = Store<AppState>(appReducer,
          initialState: AppState(
              postsFetchStatus: PostsFetchStatus(
                  isFetching: true,
                  nextStartIndex: 0,
                  postsLoaded: postsLoaded,
                  postsNewlyArrived: postsNewlyArrived)));
      final action = ActionFetchPostsFailed();
      store.dispatch(action);

      expect(selectorIsFetchingPosts(selectorPostsStatus(store.state)), false);
      expect(selectorPostsStatus(store.state).postsLoaded, postsLoaded);
      expect(selectorPostsStatus(store.state).postsNewlyArrived, []);
    });

    test(
        "should clear the cached posts, in response to an ActionUpdateFilters if the filters have been changed",
        () {
      final postsLoaded = [
        Post("username", "pictureUrl", "description", DateTime.now())
      ];
      final postsNewlyArrived = [
        Post("username1", "pictureUrl1", "description1", DateTime.now())
      ];
      final store = Store<AppState>(appReducer,
          initialState: AppState(
              postsFetchStatus: PostsFetchStatus(
                  isFetching: false,
                  nextStartIndex: 0,
                  postsLoaded: postsLoaded,
                  postsNewlyArrived: postsNewlyArrived)));
      final action = ActionUpdateFilters(Filters());
      store.dispatch(action);

      expect(selectorPostsStatus(store.state).postsLoaded, []);
      expect(selectorPostsStatus(store.state).postsNewlyArrived, []);
    });
  });
}
