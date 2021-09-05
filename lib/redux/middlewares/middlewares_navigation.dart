import 'package:instapic/redux/actions/action_navigation.dart';
import 'package:instapic/redux/actions/action_sign_in_out_up.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/ui/routes.dart';
import 'package:redux/redux.dart';

class MiddlewaresNavigation {
  List<Middleware<AppState>> getMiddlewares() {
    return [
      _signInSucceeded,
      _logoutSucceeded,
      _queryLoginStatusSucceeded,
      _routeNavigator
    ];
  }

  static void _signInSucceeded(
      Store<AppState> store, action, NextDispatcher next) {
    if (action is ActionSignInSucceeded) {
      store.dispatch(ActionNavigation(mapRouteDetails[RouteNames.browse]!));
    }
    // Make sure our actions continue on to the reducer.
    next(action);
  }

  static void _logoutSucceeded(
      Store<AppState> store, action, NextDispatcher next) {
    if (action is ActionLogoutSucceeded) {
      store.dispatch(ActionNavigation(mapRouteDetails[RouteNames.login]!));
    }
    // Make sure our actions continue on to the reducer.
    next(action);
  }

  static void _queryLoginStatusSucceeded(
      Store<AppState> store, action, NextDispatcher next) {
    if (action is ActionCheckLoginStatusSucceeded) {
      if (action.loginStatus.isLogin) {
        if (store.state.currentRoute == RouteNames.login)
          store.dispatch(ActionNavigation(mapRouteDetails[RouteNames.browse]!));
      } else {
        if (store.state.currentRoute != RouteNames.login)
          store.dispatch(ActionNavigation(mapRouteDetails[RouteNames.login]!));
      }
    }
    // Make sure our actions continue on to the reducer.
    next(action);
  }

  static void _routeNavigator(
      Store<AppState> store, action, NextDispatcher next) {
    if (action is ActionNavigation) {
      // print("Current Route: ${store.state.currentRoute}, Requested Route: ${action.routeDetails.route}");
      // GlobalWidgets.navigatorKey.currentState!
      //     .pushReplacementNamed(action.routeDetails.route);
      if(store.state.currentRoute == action.routeDetails.route) return;
    }
    // Make sure our actions continue on to the reducer.
    next(action);
  }
}
