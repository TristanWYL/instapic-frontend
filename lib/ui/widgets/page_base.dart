import 'package:flutter/material.dart';
import 'package:instapic/ui/routes.dart';
import 'package:instapic/ui/widgets/navigator_bar.dart';

class WidgetPageBase extends StatelessWidget {
  final Widget child;
  final int navigationRailIndex;
  const WidgetPageBase({Key? key, required this.child, required this.navigationRailIndex}) : 
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          WidgetNavigatorBar(navigationRailIndex: navigationRailIndex, routeList: listRouteDetailsWithoutLogin,),
          VerticalDivider(width: 1, thickness: 1,),
          Expanded(child: child),
        ],
      ),
    );
  }
}