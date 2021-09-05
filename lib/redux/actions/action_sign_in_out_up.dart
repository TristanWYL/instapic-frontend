import 'package:instapic/models/login_status.dart';

class ActionSignIn{
  final String username;
  final String password;

  ActionSignIn({required this.username, required this.password});
}
class ActionSignInSucceeded{
  final String username;

  ActionSignInSucceeded({required this.username});
}

class ActionSignUp{
  final String username;
  final String password;

  ActionSignUp({required this.username, required this.password});
}
class ActionSignUpSucceeded{
  final String username;
  final String password;

  ActionSignUpSucceeded({required this.username, required this.password});
}

class ActionLogout{}
class ActionLogoutSucceeded{}

class ActionCheckLoginStatus{}
class ActionCheckLoginStatusSucceeded{
  final LoginStatus loginStatus;
  ActionCheckLoginStatusSucceeded(this.loginStatus);
}

