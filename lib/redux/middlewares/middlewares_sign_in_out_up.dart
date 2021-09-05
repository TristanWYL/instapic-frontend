import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/login_status.dart';
import 'package:instapic/redux/actions/action_others.dart';
import 'package:instapic/redux/actions/action_sign_in_out_up.dart';
import 'package:instapic/remote/api.dart';
import 'package:instapic/remote/response.dart';
import 'package:redux/redux.dart';

class MiddlewaresSign {
  final Api api;
  MiddlewaresSign(this.api);

  List<Middleware<AppState>> getMiddlewares() {
    return [_signUp, _signUpSucceeded, _signIn, _logout, _queryLoginStatus];
  }

  void _signUp(Store<AppState> store, action, NextDispatcher next) {
    if (action is ActionSignUp) {
      api.signUp(action.username, action.password).then((apiResponse) {
        if (apiResponse.code == ApiResponse.CODE_OK) {
          store.dispatch(ActionSignUpSucceeded(
              username: action.username, password: action.password));
        } else {
          store.dispatch(ActionPromptError(apiResponse.toString()));
        }
      });
    }
    next(action);
  }

  static void _signUpSucceeded(
      Store<AppState> store, action, NextDispatcher next) {
    if (action is ActionSignUpSucceeded) {
      // sign in automatically
      store.dispatch(
          ActionSignIn(username: action.username, password: action.password));
    }
    // Make sure our actions continue on to the reducer.
    next(action);
  }

  void _signIn(Store<AppState> store, action, NextDispatcher next) {
    if (action is ActionSignIn) {
      api.signIn(action.username, action.password).then((apiResponse) {
        if (apiResponse.code == ApiResponse.CODE_OK) {
          store.dispatch(ActionSignInSucceeded(username: action.username));
        } else {
          store.dispatch(ActionPromptError(apiResponse.toString()));
        }
      });
    }
    next(action);
  }

  void _logout(Store<AppState> store, action, NextDispatcher next) {
    if (action is ActionLogout) {
      api.logOut().then((apiResponse) {
        if (apiResponse.code == ApiResponse.CODE_OK) {
          store.dispatch(ActionLogoutSucceeded());
        } else {
          store.dispatch(ActionPromptError(apiResponse.toString()));
        }
      });
    }
    next(action);
  }

  void _queryLoginStatus(Store<AppState> store, action, NextDispatcher next) {
    if (action is ActionCheckLoginStatus) {
      api.signInQuery().then((apiResponse) {
        if (apiResponse.code == ApiResponse.CODE_OK) {
          store.dispatch(ActionCheckLoginStatusSucceeded(
              LoginStatus.fromJSON(apiResponse.data)));
        } else {
          store.dispatch(ActionPromptError(apiResponse.toString()));
        }
      });
    }
    next(action);
  }
}
