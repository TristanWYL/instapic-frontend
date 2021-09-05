import 'package:instapic/models/login_status.dart';
import 'package:instapic/redux/actions/action_sign_in_out_up.dart';
import 'package:redux/redux.dart';

final reducersSign = combineReducers<LoginStatus>([
  // TypedReducer<LoginStatus, ActionSignIn>(_reducerSignIn),
  TypedReducer<LoginStatus, ActionSignInSucceeded>(_reducerSignInSucceeded),
  TypedReducer<LoginStatus, ActionSignUp>(_reducerSignUp),
  TypedReducer<LoginStatus, ActionSignUpSucceeded>(_reducerSignUpSucceeded),
  // TypedReducer<LoginStatus, ActionLogout>(_reducerLogout),
  TypedReducer<LoginStatus, ActionLogoutSucceeded>(_reducerLogoutSucceeded),
  // TypedReducer<LoginStatus, ActionCheckLoginStatus>(_reducerCheckLogin),
  TypedReducer<LoginStatus, ActionCheckLoginStatusSucceeded>(_reducerCheckLoginSucceeded)
]);

// LoginStatus _reducerSignIn(LoginStatus status, ActionSignIn action) {
//   return LoginStatus(username: action.username);
// }

LoginStatus _reducerSignInSucceeded(LoginStatus status, ActionSignInSucceeded action) {
  return LoginStatus(isLogin: true, username: action.username);
}

LoginStatus _reducerSignUp(LoginStatus status, ActionSignUp action) {
  return LoginStatus(isLogin: false);
}

LoginStatus _reducerSignUpSucceeded(LoginStatus status, ActionSignUpSucceeded action) {
  return LoginStatus(isLogin: false);
}

// LoginStatus _reducerLogout(LoginStatus status, ActionLogout action) {
//   return status;
// }

LoginStatus _reducerLogoutSucceeded(LoginStatus status, ActionLogoutSucceeded action) {
  return LoginStatus(isLogin: false);
}

// LoginStatus _reducerCheckLogin(LoginStatus status, ActionCheckLoginStatus action) {
//   return status;
// }

LoginStatus _reducerCheckLoginSucceeded(LoginStatus status, ActionCheckLoginStatusSucceeded action) {
  return action.loginStatus;
}

