import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/login_status.dart';
import 'package:instapic/redux/actions/action_sign_in_out_up.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:instapic/remote/response.dart';
import 'package:instapic/ui/routes.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';
import 'middlewares_fetch_posts_test.mocks.dart';

void main() {
  group("Middlewares testing for Signing up: ", () {

    test("signing up successfully", () async {
      final api = MockApi();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(),
        middleware: getMiddlewares(api),
      );

      
      final mockSignUpResponse = ApiResponse(200, "Sign up successfully");
      final mockSignInResponse = ApiResponse(200, "Login successfully");
      final username = "xxxxxx";
      final password = "yyyyyy";

      when(api.signUp(username, password)).thenAnswer((_) => Future.value(mockSignUpResponse));
      when(api.signIn(username, password)).thenAnswer((_) => Future.value(mockSignInResponse));

      store.dispatch(ActionSignUp(username: username, password: password));
      await untilCalled(api.signUp(username, password));

      verify(api.signUp(username, password)).called(1);
      // considering that once sign up successfully, the program will sign in automatically
      // with the previous username and password
      await untilCalled(api.signIn(username, password));
      verify(api.signIn(username, password)).called(1);
      expect(selectorCurrentRoute(store.state), RouteNames.browse);
      expect(selectorIsLogin(selectorLoginStatus(store.state)), true);
      expect(selectorUsername(selectorLoginStatus(store.state)), username);
    });

    test("failed to sign up", () async {
      final api = MockApi();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(),
        middleware: getMiddlewares(api),
      );

      
      final mockResponse = ApiResponse(400, "Failed to sign up");
      final username = "xxxxxx";
      final password = "yyyyyy";

      when(api.signUp(username, password)).thenAnswer((_) => Future.value(mockResponse));

      store.dispatch(ActionSignUp(username: username, password: password));
      await untilCalled(api.signUp(username, password));

      verify(api.signUp(username, password)).called(1);
      expect(selectorCurrentRoute(store.state), RouteNames.login);
      expect(selectorIsLogin(selectorLoginStatus(store.state)), false);
    });
  });

  group("Middlewares testing for Signing in: ", () {

    test("signing in successfully", () async {
      final api = MockApi();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(),
        middleware: getMiddlewares(api),
      );


      final mockResponse = ApiResponse(200, "Login successfully");
      final username = "xxxxxx";
      final password = "yyyyyy";

      when(api.signIn(username, password)).thenAnswer((_) => Future.value(mockResponse));

      store.dispatch(ActionSignIn(username: username, password: password));

      await untilCalled(api.signIn(username, password));
      verify(api.signIn(username, password)).called(1);
      expect(selectorCurrentRoute(store.state), RouteNames.browse);
      expect(selectorIsLogin(selectorLoginStatus(store.state)), true);
      expect(selectorUsername(selectorLoginStatus(store.state)), username);
    });

    test("failed to sign in", () async {
      final api = MockApi();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(),
        middleware: getMiddlewares(api),
      );

      
      final mockResponse = ApiResponse(400, "Failed to sign in");
      final username = "xxxxxx";
      final password = "yyyyyy";

      when(api.signIn(username, password)).thenAnswer((_) => Future.value(mockResponse));

      store.dispatch(ActionSignIn(username: username, password: password));
      await untilCalled(api.signIn(username, password));

      verify(api.signIn(username, password)).called(1);
      expect(selectorCurrentRoute(store.state), RouteNames.login);
      expect(selectorIsLogin(selectorLoginStatus(store.state)), false);
    });
  });

  
  
  group("Middlewares testing for the login status query: ", () {

    test("query successfully", () async {
      final api = MockApi();
      final username = "abase";
      var currentRoute = RouteNames.account;
      var store = Store<AppState>(
        appReducer,
        initialState: AppState(currentRoute: currentRoute, loginStatus: LoginStatus(isLogin: false)),
        middleware: getMiddlewares(api),
      );


      final mockResponseWithLogin = ApiResponse(200, "Have logged in.", data:{
            "login":true,
            "username":username
        });

      when(api.signInQuery()).thenAnswer((_) => Future.value(mockResponseWithLogin));

      store.dispatch(ActionCheckLoginStatus());

      await untilCalled(api.signInQuery());
      verify(api.signInQuery()).called(1);
      if(currentRoute == RouteNames.login) expect(selectorCurrentRoute(store.state), RouteNames.browse);
      else expect(selectorCurrentRoute(store.state), currentRoute);
      expect(selectorIsLogin(selectorLoginStatus(store.state)), true);
      expect(selectorUsername(selectorLoginStatus(store.state)), username);
      
      currentRoute = RouteNames.account;
      store = Store<AppState>(
        appReducer,
        initialState: AppState(currentRoute: currentRoute, loginStatus: LoginStatus(isLogin: true, username: username)),
        middleware: getMiddlewares(api),
      );


      final mockResponseWithoutLogin = ApiResponse(200, "Not logged in yet.", data:{
            "login":false,
            "username":null
        });

      when(api.signInQuery()).thenAnswer((_) => Future.value(mockResponseWithoutLogin));

      store.dispatch(ActionCheckLoginStatus());

      await untilCalled(api.signInQuery());
      verify(api.signInQuery()).called(1);
      expect(selectorCurrentRoute(store.state), RouteNames.login);
      expect(selectorIsLogin(selectorLoginStatus(store.state)), false);      
    });
  });
}
