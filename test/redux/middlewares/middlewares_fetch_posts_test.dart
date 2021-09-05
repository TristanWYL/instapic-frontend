import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/fetch_posts_status.dart';
import 'package:instapic/models/filters.dart';
import 'package:instapic/models/post.dart';
import 'package:instapic/redux/actions/action_fetch_posts.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:instapic/remote/api.dart';
import 'package:instapic/remote/response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';
import 'middlewares_fetch_posts_test.mocks.dart';

@GenerateMocks([Api])
void main() {
  group("Middlewares testing for Fetching Posts:", () {

    final posts = [
        {
          "username": "username1",
          "timestamp": "2021-07-17 15:00:00",
          "url": "path/to/the/picture1",
          "description": "short description of the picture1"
        },
        {
          "username": "username2",
          "timestamp": "2021-07-17 16:00:00",
          "url": "path/to/the/picture2",
          "description": "short description of the picture2"
        },
        {
          "username": "username3",
          "timestamp": "2021-07-17 17:00:00",
          "url": "path/to/the/picture3",
          "description": "short description of the picture4"
        },
        {
          "username": "username4",
          "timestamp": "2021-07-17 18:00:00",
          "url": "path/to/the/picture3",
          "description": "short description of the picture4"
        }
      ];

    test("fetching posts successfully", () async {
      final api = MockApi();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(),
        middleware: getMiddlewares(api),
      );

      
      final mockResponse = ApiResponse(200, "Query successfully", data: posts);

      when(api.posts(
        username: anyNamed("username"),
        sortby: anyNamed("sortby"),
        order: anyNamed("order"),
      )).thenAnswer((_) => Future.value(mockResponse));

      store.dispatch(ActionFetchPosts(filters: Filters()));
      await untilCalled(api.posts());
      verify(api.posts()).called(1);

      expect(selectorIsFetchingPosts(selectorPostsStatus(store.state)), false);
      expect(selectorPostsStatus(store.state).nextStartIndex, posts.length);
      expect(selectorPostsStatus(store.state).postsLoaded, List<Post>.generate(posts.length, (index) => Post.fromJSON(posts[index])));
      expect(selectorPostsStatus(store.state).postsNewlyArrived, List<Post>.generate(posts.length, (index) => Post.fromJSON(posts[index])));
    });

    test("failed to fetch posts", () async {
      final api = MockApi();
      final postsFetchStatus = PostsFetchStatus(
        isFetching: false, 
        nextStartIndex: posts.length, 
        postsLoaded: List<Post>.generate(posts.length, (index) => Post.fromJSON(posts[index])), 
        postsNewlyArrived: List<Post>.generate(posts.length, (index) => Post.fromJSON(posts[index])));
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(postsFetchStatus: postsFetchStatus),
        middleware: getMiddlewares(api),
      );

      final mockResponse = ApiResponse(400, "xxxx", data: posts);

      when(api.posts(
        username: anyNamed("username"),
        sortby: anyNamed("sortby"),
        order: anyNamed("order"),
      )).thenAnswer((_) => Future.value(mockResponse));

      // This will give an async assertion error, as it is async, 
      // it cannot be captured by [try] or [expect]
      // We should try to test this in WidgetTesting
      store.dispatch(ActionFetchPosts(filters: Filters()));

      await untilCalled(api.posts());
      verify(api.posts()).called(1);

      expect(selectorIsFetchingPosts(selectorPostsStatus(store.state)), false);
      expect(selectorPostsStatus(store.state).nextStartIndex, posts.length);
      expect(selectorPostsStatus(store.state).postsLoaded, List<Post>.generate(posts.length, (index) => Post.fromJSON(posts[index])));
      expect(selectorPostsStatus(store.state).postsNewlyArrived, []);
    });
  });
}
