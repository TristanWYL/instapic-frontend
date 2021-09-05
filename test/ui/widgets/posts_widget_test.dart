import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/fetch_posts_status.dart';
import 'package:instapic/models/post.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/remote/response.dart';
import 'package:instapic/ui/keys.dart';
import 'package:instapic/ui/widgets/posts_widget.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import '../../redux/middlewares/middlewares_fetch_posts_test.mocks.dart';
import '../ui_base_for_testing.dart';

void main() {
  // get ready some fake posts
  final posts = <Post>[];
  for(var i = 0; i<10; i++){
    posts.add(Post("username$i", "http://placehold.it/120x120&text=image$i", "This is the ${i}th picture.", DateTime.now()));
  }

  testWidgets('PostHolder should render the carried post', (WidgetTester tester) async {
    final post = posts.first;
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: PostHolder(post:post), store: store,));

    expect(find.byType(CachedNetworkImage), findsNWidgets(1));
    expect(find.text(post.username), findsNWidgets(1));
    expect(find.text(post.description), findsNWidgets(1));
  });

  testWidgets('PagedImageListView should render all posts already loaded and stored in [AppState.postsFetchStatus.postsLoaded]', (WidgetTester tester) async {
    final api = MockApi();
    final msg = "Query successfully";
    final mockResponse = ApiResponse(200, msg, data: []);
    when(api.posts(start:posts.length, username: anyNamed("username"), sortby: anyNamed("sortby"), order: anyNamed("order"))).thenAnswer((_) => Future.value(mockResponse));

    var store = Store<AppState>(
      appReducer,
      initialState: AppState(postsFetchStatus: PostsFetchStatus(isFetching: false, nextStartIndex: posts.length, postsLoaded: posts, postsNewlyArrived: [])),
      middleware: getMiddlewares(api),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: PagedImageListView(), store: store,));

    await untilCalled(api.posts(start:posts.length, username: anyNamed("username"), sortby: anyNamed("sortby"), order: anyNamed("order")));
    verify(api.posts(start:posts.length, username: anyNamed("username"), sortby: anyNamed("sortby"), order: anyNamed("order"))).called(1);

    expect(find.byType(ListView), findsOneWidget);
    for(var i =0; i<posts.length;i++){
      await tester.dragUntilVisible(find.text(posts[i].description), find.byType(ListView), Offset(0, -100));
      await tester.pump(Duration(seconds: 10));
      expect(find.text(posts[i].username), findsOneWidget);
      expect(find.text(posts[i].description), findsOneWidget);
    }
  });

  testWidgets('PagedImageListView should render a [CircularProgressIndicator] when trying to load more posts by dragging the [ListView] bottom end upwards.', (WidgetTester tester) async {
    final api = MockApi();
    final msg = "Query successfully";
    final mockResponse = ApiResponse(200, msg, data: []);
    when(api.posts(start:posts.length, username: anyNamed("username"), sortby: anyNamed("sortby"), order: anyNamed("order"))).thenAnswer((_) => Future.delayed(Duration(seconds: 2), ()=>Future.value(mockResponse)));

    var store = Store<AppState>(
      appReducer,
      initialState: AppState(postsFetchStatus: PostsFetchStatus(isFetching: false, nextStartIndex: posts.length, postsLoaded: posts, postsNewlyArrived: [])),
      middleware: getMiddlewares(api),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: PagedImageListView(), store: store,));

    await untilCalled(api.posts(start:posts.length, username: anyNamed("username"), sortby: anyNamed("sortby"), order: anyNamed("order")));
    verify(api.posts(start:posts.length, username: anyNamed("username"), sortby: anyNamed("sortby"), order: anyNamed("order"))).called(1);

    expect(find.byType(ListView), findsOneWidget);
    for(var i =0; i<posts.length;i++){
      await tester.dragUntilVisible(find.text(posts[i].description), find.byType(ListView), Offset(0, -100));
      await tester.pump(Duration(seconds: 10));
      expect(find.text(posts[i].username), findsOneWidget);
      expect(find.text(posts[i].description), findsOneWidget);
    }
    await tester.dragUntilVisible(find.text(posts.last.description), find.byType(ListView), Offset(0, -200));

    reset(api);
    when(api.posts(start:posts.length, username: anyNamed("username"), sortby: anyNamed("sortby"), order: anyNamed("order"))).thenAnswer((_) => Future.delayed(Duration(seconds: 2), ()=>Future.value(mockResponse)));
    await tester.drag(find.byType(ListView), Offset(0, 200));
    await tester.drag(find.byType(ListView), Offset(0, -400));
    await tester.pump(Duration(seconds: 1));
    expect(find.byKey(Key(WidgetKeys.circularProgressIndicatorForLoading)), findsOneWidget);

    await untilCalled(api.posts(start:posts.length, username: anyNamed("username"), sortby: anyNamed("sortby"), order: anyNamed("order")));
    verify(api.posts(start:posts.length, username: anyNamed("username"), sortby: anyNamed("sortby"), order: anyNamed("order"))).called(1);

    await tester.pump(Duration(seconds: 5));
    expect(find.text("No more posts!"), findsOneWidget);
  });
}