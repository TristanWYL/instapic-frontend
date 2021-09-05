import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/login_status.dart';
import 'package:instapic/redux/actions/action_sign_in_out_up.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:instapic/remote/api.dart';
import 'package:instapic/ui/routes.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';

void main() {
  group("Middlewares testing for Navigating routes:", () {
    test("should redirect to browser route after login", () async {
      final api = Api();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(currentRoute: RouteNames.login),
        middleware: getMiddlewares(api),
      );
      final username = "xxx";
      store.dispatch(ActionSignInSucceeded(username: username));
      expect(selectorCurrentRoute(store.state), RouteNames.browse);
      expect(selectorUsername(selectorLoginStatus(store.state)), username);
      expect(selectorIsLogin(selectorLoginStatus(store.state)), true);
    });

    test("should redirect to login route after logout", () async {
      final api = Api();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(currentRoute: RouteNames.account, loginStatus: LoginStatus(isLogin: true, username: "xx")),
        middleware: getMiddlewares(api),
      );
      store.dispatch(ActionLogoutSucceeded());
      expect(selectorCurrentRoute(store.state), RouteNames.login);
      expect(selectorIsLogin(selectorLoginStatus(store.state)), false);
    });

    test("should redirect to corresponding routes in response to ActionCheckLoginStatusSucceeded", () async {
      final api = Api();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(currentRoute: RouteNames.account, loginStatus: LoginStatus(isLogin: true, username: "xx")),
        middleware: getMiddlewares(api),
      );

      // not logged in
      store.dispatch(ActionCheckLoginStatusSucceeded(LoginStatus()));
      expect(selectorCurrentRoute(store.state), RouteNames.login);
      expect(selectorIsLogin(selectorLoginStatus(store.state)), false);

      final store1 = Store<AppState>(
        appReducer,
        initialState: AppState(currentRoute: RouteNames.login),
        middleware: getMiddlewares(api),
      );
      // logged in
      final username = "xxxx";
      store1.dispatch(ActionCheckLoginStatusSucceeded(LoginStatus(isLogin: true, username: username)));
      expect(selectorCurrentRoute(store1.state), RouteNames.browse);
      expect(selectorIsLogin(selectorLoginStatus(store1.state)), true);
      expect(selectorUsername(selectorLoginStatus(store1.state)), username);
    });
  });
}
