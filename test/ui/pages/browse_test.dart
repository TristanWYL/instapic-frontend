// test the interaction with the api
// test the image-loading process with the api
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/fetch_posts_status.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/remote/response.dart';
import 'package:instapic/ui/keys.dart';
import 'package:instapic/ui/pages/browse.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import '../../redux/middlewares/middlewares_fetch_posts_test.mocks.dart';
import '../ui_base_for_testing.dart';

void main() {
  // get ready some fake postsWillBeFetched
  final postsWillBeFetched = <Map<String, String>>[];
  for (var i = 0; i < 10; i++) {
    postsWillBeFetched.add({
      'username': "username$i",
      'url': "http://placehold.it/120x120&text=image$i",
      'description': "This is the ${i}th picture.",
      'timestamp': "${DateTime.now()}"
    });
  }

  final postsWillBeFetchedAgain = <Map<String, String>>[];
  for (var i = 10; i < 20; i++) {
    postsWillBeFetchedAgain.add({
      'username': "username$i",
      'url': "http://placehold.it/120x120&text=image$i",
      'description': "This is the ${i}th picture.",
      'timestamp': "${DateTime.now()}"
    });
  }

  final postsEmpty = <Map<String, String>>[];

  testWidgets('PageBrowser should try to fetch the posts when first launched.',
      (WidgetTester tester) async {
    final api = MockApi();
    final msg = "Query successfully";
    final mockResponse = ApiResponse(200, msg, data: postsWillBeFetched);
    when(api.posts(
            start: 0,
            username: anyNamed("username"),
            sortby: anyNamed("sortby"),
            order: anyNamed("order")))
        .thenAnswer((_) => Future.value(mockResponse));
    final mockResponseSecond = ApiResponse(200, msg, data: []);
    when(api.posts(
            start: 10,
            username: anyNamed("username"),
            sortby: anyNamed("sortby"),
            order: anyNamed("order")))
        .thenAnswer((_) => Future.value(mockResponseSecond));

    var store = Store<AppState>(
      appReducer,
      initialState: AppState(
          postsFetchStatus: PostsFetchStatus(
              isFetching: false,
              nextStartIndex: 0,
              postsLoaded: [],
              postsNewlyArrived: [])),
      middleware: getMiddlewares(api),
    );
    await tester.pumpWidget(ScaffoldBase(
      testWidget: PageBrowser(
        pageID: 1,
      ),
      store: store,
    ));

    await untilCalled(api.posts(
        start: 0,
        username: anyNamed("username"),
        sortby: anyNamed("sortby"),
        order: anyNamed("order")));
    verify(api.posts(
            start: 0,
            username: anyNamed("username"),
            sortby: anyNamed("sortby"),
            order: anyNamed("order")))
        .called(1);
    await tester.pump(Duration(seconds: 10));

    for (var i = 0; i < postsWillBeFetched.length; i++) {
      await tester.dragUntilVisible(
          find.text(postsWillBeFetched[i]["description"]!),
          find.byType(ListView),
          Offset(0, -100));
      await tester.pump(Duration(seconds: 10));
      expect(find.text(postsWillBeFetched[i]["username"]!), findsOneWidget);
      expect(find.text(postsWillBeFetched[i]["description"]!), findsOneWidget);
    }

    await untilCalled(api.posts(
        start: 10,
        username: anyNamed("username"),
        sortby: anyNamed("sortby"),
        order: anyNamed("order")));
    verify(api.posts(
            start: 10,
            username: anyNamed("username"),
            sortby: anyNamed("sortby"),
            order: anyNamed("order")))
        .called(1);
    await tester.pump(Duration(seconds: 5));
    expect(find.text("No more posts!"), findsOneWidget);
  });

  testWidgets(
      'PageBrowser should try to fetch the posts again when the [ListView] is scrolled down to the end.',
      (WidgetTester tester) async {
    final api = MockApi();
    final msg = "Query successfully";
    final mockResponse = ApiResponse(200, msg, data: postsWillBeFetched);
    when(api.posts(
            start: 0,
            username: anyNamed("username"),
            sortby: anyNamed("sortby"),
            order: anyNamed("order")))
        .thenAnswer((_) => Future.value(mockResponse));
    final mockResponseSecond =
        ApiResponse(200, msg, data: postsWillBeFetchedAgain);
    when(api.posts(
            start: 10,
            username: anyNamed("username"),
            sortby: anyNamed("sortby"),
            order: anyNamed("order")))
        .thenAnswer((_) => Future.delayed(
            Duration(seconds: 2), () => Future.value(mockResponseSecond)));
    final mockResponseLast = ApiResponse(200, msg, data: postsEmpty);
    when(api.posts(
            start: 20,
            username: anyNamed("username"),
            sortby: anyNamed("sortby"),
            order: anyNamed("order")))
        .thenAnswer((_) => Future.delayed(
            Duration(seconds: 2), () => Future.value(mockResponseLast)));

    var store = Store<AppState>(
      appReducer,
      initialState: AppState(
          postsFetchStatus: PostsFetchStatus(
              isFetching: false,
              nextStartIndex: 0,
              postsLoaded: [],
              postsNewlyArrived: [])),
      middleware: getMiddlewares(api),
    );
    await tester.pumpWidget(ScaffoldBase(
      testWidget: PageBrowser(
        pageID: 1,
      ),
      store: store,
    ));

    await untilCalled(api.posts(
        start: 0,
        username: anyNamed("username"),
        sortby: anyNamed("sortby"),
        order: anyNamed("order")));
    verify(api.posts(
            start: 0,
            username: anyNamed("username"),
            sortby: anyNamed("sortby"),
            order: anyNamed("order")))
        .called(1);
    await tester.pump(Duration(seconds: 10));

    for (var i = 0; i < postsWillBeFetched.length; i++) {
      await tester.dragUntilVisible(
          find.text(postsWillBeFetched[i]["description"]!),
          find.byType(ListView),
          Offset(0, -100));
      await tester.pump(Duration(seconds: 1));
      expect(find.text(postsWillBeFetched[i]["username"]!), findsOneWidget);
      expect(find.text(postsWillBeFetched[i]["description"]!), findsOneWidget);
    }

    expect(find.byKey(Key(WidgetKeys.circularProgressIndicatorForLoading)),
        findsOneWidget);

    await untilCalled(api.posts(
        start: 10,
        username: anyNamed("username"),
        sortby: anyNamed("sortby"),
        order: anyNamed("order")));
    verify(api.posts(
            start: 10,
            username: anyNamed("username"),
            sortby: anyNamed("sortby"),
            order: anyNamed("order")))
        .called(1);

    await tester.pump(Duration(seconds: 3));
    expect(find.byKey(Key(WidgetKeys.circularProgressIndicatorForLoading)),
        findsNothing);

    for (var i = 0; i < postsWillBeFetchedAgain.length; i++) {
      await tester.dragUntilVisible(
          find.text(postsWillBeFetchedAgain[i]["description"]!),
          find.byType(ListView),
          Offset(0, -100));
      await tester.pump(Duration(seconds: 1));
      expect(
          find.text(postsWillBeFetchedAgain[i]["username"]!), findsOneWidget);
      expect(find.text(postsWillBeFetchedAgain[i]["description"]!),
          findsOneWidget);
    }

    expect(find.byKey(Key(WidgetKeys.circularProgressIndicatorForLoading)),
        findsOneWidget);

    await tester.pump(Duration(seconds: 5));
    expect(find.byKey(Key(WidgetKeys.circularProgressIndicatorForLoading)),
        findsNothing);
    expect(find.text("No more posts!"), findsOneWidget);
  });
}
