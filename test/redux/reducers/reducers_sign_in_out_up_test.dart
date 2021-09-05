import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/login_status.dart';
import 'package:instapic/redux/actions/action_sign_in_out_up.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:redux/redux.dart';

void main() {
  group("Reducers for LoginStatus", (){
    test("should change the state of 'LoginStatus', in response to ActionSignInSucceeded", (){
      final username = "xx";
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(loginStatus: LoginStatus(username: username))
      );
      final action = ActionSignInSucceeded(username: username);
      store.dispatch(action);
      expect(selectorIsLogin(selectorLoginStatus(store.state)), true);
      expect(selectorLoginStatus(store.state).username, username);
    });

    test("should make sure that it is not logged in, in response to ActionSignUp", (){
      final random = Random();
      final username = "xx";
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(loginStatus: LoginStatus(username: username, isLogin: random.nextBool()))
      );
      final action = ActionSignUp(username: "xxxxx", password: "yyyyyyy");
      store.dispatch(action);
      expect(selectorIsLogin(selectorLoginStatus(store.state)), false);
    });

    test("should make sure that it is not logged in, in response to ActionSignUpSucceeded", (){
      final random = Random();
      final username = "xx";
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(loginStatus: LoginStatus(username: username, isLogin: random.nextBool()))
      );
      final action = ActionSignUpSucceeded(username: "xxxxx", password: "yyyyyyy");
      store.dispatch(action);
      expect(selectorIsLogin(selectorLoginStatus(store.state)), false);
    });

    test("should change the state of 'LoginStatus', in response to ActionLogoutSucceeded", (){
      final username = "xx";
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(loginStatus: LoginStatus(isLogin: true, username: username))
      );
      final action = ActionLogoutSucceeded();
      store.dispatch(action);
      expect(selectorIsLogin(selectorLoginStatus(store.state)), false);
    });

    test("should change the state of 'isPosting' as 'false', in response to ActionCheckLoginStatusSucceeded", (){
      final store = Store<AppState>(
        appReducer,
        initialState: AppState()
      );
      final loginStatus = LoginStatus(isLogin: true, username: "xx");
      final action = ActionCheckLoginStatusSucceeded(loginStatus);
      store.dispatch(action);
      expect(selectorLoginStatus(store.state), loginStatus);
    });
  });
}