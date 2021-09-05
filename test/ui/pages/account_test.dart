import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/login_status.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:instapic/remote/response.dart';
import 'package:instapic/ui/pages/account.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import '../../redux/middlewares/middlewares_fetch_posts_test.mocks.dart';
import '../ui_base_for_testing.dart';

void main() {
  testWidgets(
      'Acount page will send a logout request, and it will log out if the request succeeds.',
      (WidgetTester tester) async {
    final username = "xxxxxx";
    final api = MockApi();
    final state =
        AppState(loginStatus: LoginStatus(isLogin: true, username: username));
    var store = Store<AppState>(
      appReducer,
      initialState: state,
      middleware: getMiddlewares(api),
    );
    await tester.pumpWidget(ScaffoldBase(
      testWidget: PageAccount(
        pageID: 0,
      ),
      store: store,
    ));
    expect(find.text(username[0]), findsOneWidget);
    expect(find.text(username.substring(1)), findsOneWidget);
    expect(find.text("Logout"), findsOneWidget);

    final mockResponse = ApiResponse(200, "Sign out successfully");
    when(api.logOut()).thenAnswer((_) => Future.value(mockResponse));

    // should be in login status before clicking on "log out"
    expect(selectorIsLogin(selectorLoginStatus(store.state)), true);

    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();

    await untilCalled(api.logOut());
    verify(api.logOut()).called(1);
    expect(selectorIsLogin(selectorLoginStatus(store.state)), false);
  });
}
