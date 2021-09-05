// test the business logic related to this page


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/fetch_posts_status.dart';
import 'package:instapic/models/post.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:instapic/ui/keys.dart';
import 'package:instapic/ui/pages/filters.dart';
import 'package:instapic/ui/routes.dart';
import 'package:redux/redux.dart';
import '../../redux/middlewares/middlewares_fetch_posts_test.mocks.dart';
import '../ui_base_for_testing.dart';

void main() {

  testWidgets('Filter page will navigate to browser page after clicking on the "Confirm" button', (WidgetTester tester) async {

    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: PageFilters(pageID: 2,), store: store,));
    await tester.tap(find.byKey(Key(WidgetKeys.btnConfirmUpdateFilters)));
    await tester.pumpAndSettle();

    expect(selectorCurrentRoute(store.state), RouteNames.browse);
  });

  testWidgets('Filter page will navigate to browser page after clicking on the "Cancel" button', (WidgetTester tester) async {

    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: PageFilters(pageID: 2,), store: store,));
    await tester.tap(find.byKey(Key(WidgetKeys.btnCancelUpdateFilters)));
    await tester.pumpAndSettle();

    expect(selectorCurrentRoute(store.state), RouteNames.browse);
  });

  testWidgets('Filter update will clear the cached posts data in app state.', (WidgetTester tester) async {
    final postsFake = [
        Post("username1", "pictureUrl1", "description1", DateTime.now()),
        Post("username2", "pictureUrl2", "description2", DateTime.now()),
      ];
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(postsFetchStatus: PostsFetchStatus(isFetching: false, nextStartIndex: postsFake.length, postsLoaded: postsFake, postsNewlyArrived: postsFake)),
      middleware: getMiddlewares(MockApi()),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: PageFilters(pageID: 2,), store: store,));

    // we should update the filters a little bit, to trigger the [ActionUpdateFilters]
    await tester.enterText(find.byType(TextField), "xxxx");
    await tester.pumpAndSettle();
    
    await tester.tap(find.byKey(Key(WidgetKeys.btnConfirmUpdateFilters)));
    await tester.pumpAndSettle();

    expect(selectorPostsStatus(store.state).postsLoaded, []);
    expect(selectorPostsStatus(store.state).postsNewlyArrived, []);
    expect(selectorPostsStatus(store.state).nextStartIndex, 0);
  });
}
