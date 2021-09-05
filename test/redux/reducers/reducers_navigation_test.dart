import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/actions/action_navigation.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:instapic/ui/routes.dart';
import 'package:redux/redux.dart';

void main() {
  group("Reducers for Filters", (){
    test("should update the filters, in response to ActionUpdateFilters", (){
      final lastRoute = "lastRoute";
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(currentRoute: lastRoute)
      );
      final currentRoute = Random().nextInt(10000).toString();
      final action = ActionNavigation(RouteDetails(
                      route: currentRoute,
                      page: Center(),
                      navigationBarIcon: const Icon(Icons.access_alarm),
                      navigationBarLabel: currentRoute
                    ));
      store.dispatch(action);
      expect(selectorCurrentRoute(store.state), currentRoute);
    });
  });
}