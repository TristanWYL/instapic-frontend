import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/actions/action_sign_in_out_up.dart';
import 'package:instapic/ui/keys.dart';
import 'package:instapic/ui/widgets/login_widget.dart';

class PageLogin extends StatefulWidget {
  PageLogin({Key? key}) : super(key: key);

  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  @override
  void initState() {
    super.initState();
    StoreProvider.of<AppState>(context, listen: false)
        .dispatch(ActionCheckLoginStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  WidgetSign(
                  key: Key(WidgetKeys.loginPage),
                ),
                ],
              ),
            )));
  }
}
