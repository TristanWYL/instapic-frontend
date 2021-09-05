import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/actions/action_navigation.dart';
import 'package:instapic/ui/routes.dart';

class WidgetNavigatorBar extends StatelessWidget {
  WidgetNavigatorBar({Key? key, required this.navigationRailIndex, required this.routeList})
      : super(key: key);
  final int navigationRailIndex;
  final List<RouteDetails> routeList;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraint.maxHeight),
          child: IntrinsicHeight(
            child: NavigationRail(
              selectedIndex: navigationRailIndex,
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: (index) async {
                // StoreProvider.of<AppState>(context, listen: false).dispatch(ActionCheckLoginStatus());
                StoreProvider.of<AppState>(context, listen: false).dispatch(
                    ActionNavigation(routeList[index]));
              },
              destinations:
                  List.generate(routeList.length, (index) {
                return NavigationRailDestination(
                    icon: routeList[index].navigationBarIcon,
                    label: Text(routeList[index]
                        .navigationBarLabel));
              }),
            ),
          ),
        ),
      );
    });
  }
}
