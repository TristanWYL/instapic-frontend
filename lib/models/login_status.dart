// A class for storing the login status
class LoginStatus {
  final bool isLogin;
  final String? username;
  const LoginStatus({this.isLogin = false, this.username});
  LoginStatus.fromJSON(Map<String, dynamic> json)
      : isLogin = json["login"],
        username = json["username"];

  @override
  int get hashCode => isLogin.hashCode ^ username.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginStatus &&
          runtimeType == other.runtimeType &&
          isLogin == other.isLogin &&
          username == other.username;
}
