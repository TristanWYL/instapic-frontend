import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:instapic/ui/routes.dart';
import 'package:instapic/ui/widgets/navigator_bar.dart';
import 'package:redux/redux.dart';
import '../../redux/middlewares/middlewares_fetch_posts_test.mocks.dart';
import '../ui_base_for_testing.dart';

void main() {

  testWidgets('Navigation bar can switch pages when clicking on the icon in the bar.', (WidgetTester tester) async {

    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );

    RouteDetails rd1 = RouteDetails(route: "route1", page: Container(), navigationBarIcon: Icon(Icons.looks_one, key: Key("icon1"),), navigationBarLabel: "label1");
    RouteDetails rd2 = RouteDetails(route: "route2", page: Container(), navigationBarIcon: Icon(Icons.looks_two, key: Key("icon2"),), navigationBarLabel: "label2");
    RouteDetails rd3 = RouteDetails(route: "route3", page: Container(), navigationBarIcon: Icon(Icons.looks_3, key: Key("icon3"),), navigationBarLabel: "label3");
    RouteDetails rd4 = RouteDetails(route: "route4", page: Container(), navigationBarIcon: Icon(Icons.looks_4, key: Key("icon4"),), navigationBarLabel: "label4");
    RouteDetails rd5 = RouteDetails(route: "route5", page: Container(), navigationBarIcon: Icon(Icons.looks_5, key: Key("icon5"),), navigationBarLabel: "label5");

    final routeList = [rd1, rd2, rd3, rd4, rd5];
    final currentIndex = Random().nextInt(routeList.length);
    final nextIndex = Random().nextInt(routeList.length);

    await tester.pumpWidget(ScaffoldBase(testWidget: WidgetNavigatorBar(navigationRailIndex: currentIndex, routeList: routeList,), store: store,));

    routeList.forEach((element) {
      expect(find.text(element.navigationBarLabel), findsOneWidget);
      expect(find.byKey(element.navigationBarIcon.key!), findsOneWidget);
    });


    await tester.tap(find.byKey(Key("icon${nextIndex+1}")));
    await tester.pumpAndSettle();
    
    expect(selectorCurrentRoute(store.state), "route${nextIndex+1}");
  });
}