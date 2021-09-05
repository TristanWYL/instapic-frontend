import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:instapic/ui/routes.dart';
import 'package:redux/redux.dart';

class PageBase extends StatelessWidget {
  const PageBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StoreConnector<AppState, _ViewModel>(
          distinct: true,
          converter: _ViewModel.fromStore,
          builder: (context, vm)=>mapRouteDetails[vm.currentRoute]!.page),
      );
  }
}

class _ViewModel {
  final String currentRoute;

  _ViewModel({
    required this.currentRoute,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      currentRoute: selectorCurrentRoute(store.state),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          currentRoute == other.currentRoute;

  @override
  int get hashCode => currentRoute.hashCode;
}