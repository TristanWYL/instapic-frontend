import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/login_status.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/ui/widgets/account.dart';
import 'package:redux/redux.dart';
import '../../redux/middlewares/middlewares_fetch_posts_test.mocks.dart';
import '../ui_base_for_testing.dart';

void main() {
  testWidgets('WidgetAccount has two text wights to show the username, and one button showing "Logout".', (WidgetTester tester) async {
    final username = "xxxxxx";
    final state = AppState(loginStatus: LoginStatus(isLogin: true, username: username));
    var store = Store<AppState>(
      appReducer,
      initialState: state,
      middleware: getMiddlewares(MockApi()),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: WidgetAccount(), store: store,));
    expect(find.text(username[0]), findsOneWidget);
    expect(find.text(username.substring(1)), findsOneWidget);
    expect(find.text("Logout"), findsOneWidget);
  });
}