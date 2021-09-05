import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/login_status.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:instapic/remote/response.dart';
import 'package:instapic/ui/keys.dart';
import 'package:instapic/ui/pages/page_base.dart';
import 'package:instapic/ui/routes.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import '../../redux/middlewares/middlewares_fetch_posts_test.mocks.dart';
import '../ui_base_for_testing.dart';

void main() {
  testWidgets(
      'The navigation bar should be able to switch pages when clicking on its icons.',
      (WidgetTester tester) async {
    final username = "xxxxxx";
    final api = MockApi();
    final msg = "Query successfully";
    final mockResponse = ApiResponse(200, msg, data: []);
    when(api.posts(
            start: 0,
            username: anyNamed("username"),
            sortby: anyNamed("sortby"),
            order: anyNamed("order")))
        .thenAnswer((_) => Future.value(mockResponse));

    final state = AppState(
        loginStatus: LoginStatus(isLogin: true, username: username),
        currentRoute: RouteNames.account);
    var store = Store<AppState>(
      appReducer,
      initialState: state,
      middleware: getMiddlewares(api),
    );
    await tester.pumpWidget(ScaffoldBase(
      testWidget: PageBase(),
      store: store,
    ));

    // switch to browse page
    await tester.tap(find.byKey(Key(WidgetKeys.browsePageMenuIcon)));
    await tester.pumpAndSettle();
    expect(find.byKey(Key(WidgetKeys.browsePage)), findsOneWidget);
    expect(selectorCurrentRoute(store.state), RouteNames.browse);

    // switch to filters page
    await tester.tap(find.byKey(Key(WidgetKeys.filtersPageMenuIcon)));
    await tester.pumpAndSettle();
    expect(find.byKey(Key(WidgetKeys.filtersPage)), findsOneWidget);
    expect(selectorCurrentRoute(store.state), RouteNames.filters);

    // switch to upload page
    await tester.tap(find.byKey(Key(WidgetKeys.uploadPageMenuIcon)));
    await tester.pumpAndSettle();
    expect(find.byKey(Key(WidgetKeys.uploadPage)), findsOneWidget);
    expect(selectorCurrentRoute(store.state), RouteNames.upload);

    // switch to about page
    await tester.tap(find.byKey(Key(WidgetKeys.aboutPageMenuIcon)));
    await tester.pumpAndSettle();
    expect(find.byKey(Key(WidgetKeys.aboutPage)), findsOneWidget);
    expect(selectorCurrentRoute(store.state), RouteNames.about);

    // switch back to account page
    await tester.tap(find.byKey(Key(WidgetKeys.accountPageMenuIcon)));
    await tester.pumpAndSettle();
    expect(find.byKey(Key(WidgetKeys.accountPage)), findsOneWidget);
    expect(selectorCurrentRoute(store.state), RouteNames.account);
  });
}
