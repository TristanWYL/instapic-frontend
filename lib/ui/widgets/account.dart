import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/actions/action_sign_in_out_up.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:redux/redux.dart';

class WidgetAccount extends StatelessWidget {
  const WidgetAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      margin: EdgeInsets.symmetric(horizontal: 100, vertical: 100),
      child: Center(
        child: StoreConnector<AppState, _ViewModel>(
          distinct: true,
          ignoreChange: (state) => selectorUsername(selectorLoginStatus(state)) == "",
          converter: _ViewModel.fromStore,
          builder: (context, vm) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _getUserNameWidget(vm.username),
              SizedBox(
                height: 30,
              ),
              Divider(
                thickness: 1,
                height: 1,
              ),
              SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: vm.onPressLogout,
                  child: Text(
                    "Logout",
                    style: TextStyle(fontSize: 20),
                  )),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _getUserNameWidget(String username) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.orange,
          // shape: BoxShape.circlehao
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        child: Center(
          child: Text(
            username[0],
            style: TextStyle(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Text(
          username.substring(1),
          style: TextStyle(color: Colors.orange, fontSize: 30),
        ),
      ),
    ],
  );
}

class _ViewModel {
  final Function() onPressLogout;
  final String username;

  _ViewModel({
    required this.onPressLogout,
    required this.username,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        onPressLogout: () {
          store.dispatch(ActionLogout());
        },
        username: selectorUsername(selectorLoginStatus(store.state)));
  }

  int get hashCode =>
      username.hashCode;

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          username == other.username;
}
