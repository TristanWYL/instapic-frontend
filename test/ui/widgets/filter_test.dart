import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/filters.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:instapic/ui/keys.dart';
import 'package:instapic/ui/widgets/filter.dart';
import 'package:redux/redux.dart';
import '../../redux/middlewares/middlewares_fetch_posts_test.mocks.dart';
import '../ui_base_for_testing.dart';

void main() {
  testWidgets('WidgetFilter has some controls which users can interact with.', (WidgetTester tester) async {
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: WidgetFilter(), store: store,));
    expect(find.byType(TextField), findsNWidgets(1));
    Type typeOf<T>() => T;
    expect(find.byType(typeOf<Radio<QuerySortBy>>()), findsNWidgets(3));
    expect(find.byType(typeOf<Radio<QuerySortOrder>>()), findsNWidgets(2));
    expect(find.byType(FloatingActionButton), findsNWidgets(2));
  });

  testWidgets('WidgetFilter can render the filters model.', (WidgetTester tester) async {
    // final username = "addafa${Random().nextInt(10000)}";
    final sortby = Random().nextBool()?QuerySortBy.TIME:QuerySortBy.USER;
    final order = Random().nextBool()?QuerySortOrder.ASCENDING:QuerySortOrder.DESCENDING;
    final filters = Filters(sortby: sortby, order: order);
    final state = AppState(filters: filters);
    var store = Store<AppState>(
      appReducer,
      initialState: state,
      middleware: getMiddlewares(MockApi()),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: WidgetFilter(), store: store,));
    
    await tester.tap(find.byKey(Key(WidgetKeys.btnConfirmUpdateFilters)));
    await tester.pumpAndSettle();

    expect(selectorFilters(store.state), filters);
  });

  testWidgets('WidgetFilter can update the filters: username/sortby/order', (WidgetTester tester) async {
    // sorby group
    final sortbyRandom = Random().nextBool();
    final sortby = sortbyRandom?QuerySortBy.TIME:QuerySortBy.USER;
    final sortbyKeyWillTap = sortbyRandom?WidgetKeys.radioSortbyTime:WidgetKeys.radioSortbyUsername;

    // order group
    final orderRandom = Random().nextBool();
    final order = orderRandom?QuerySortOrder.ASCENDING:QuerySortOrder.DESCENDING;
    final orderKeyWillTap = orderRandom?WidgetKeys.radioOrderAscending:WidgetKeys.radioOrderDescending;

    final state = AppState();
    var store = Store<AppState>(
      appReducer,
      initialState: state,
      middleware: getMiddlewares(MockApi()),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: WidgetFilter(), store: store,));

    await tester.enterText(find.byType(TextField), "");
    await tester.tap(find.byKey(Key(sortbyKeyWillTap)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key(orderKeyWillTap)));
    await tester.tap(find.byKey(Key(WidgetKeys.btnConfirmUpdateFilters)));
    await tester.pumpAndSettle();

    expect(selectorFilters(store.state).sortby, sortby);
    expect(selectorFilters(store.state).order, order);
  });

  testWidgets('WidgetFilter can cancel the update of filters: username/sortby/order', (WidgetTester tester) async {
    final _sortby = Random().nextBool()?QuerySortBy.TIME:QuerySortBy.USER;
    final _order = Random().nextBool()?QuerySortOrder.ASCENDING:QuerySortOrder.DESCENDING;
    final _filters = Filters(sortby: _sortby, order: _order);

    // sorby group
    final sortbyRandom = Random().nextBool();
    final sortbyKeyWillTap = sortbyRandom?WidgetKeys.radioSortbyTime:WidgetKeys.radioSortbyUsername;

    // order group
    final orderRandom = Random().nextBool();
    final orderKeyWillTap = orderRandom?WidgetKeys.radioOrderAscending:WidgetKeys.radioOrderDescending;

    final state = AppState(filters: _filters);
    var store = Store<AppState>(
      appReducer,
      initialState: state,
      middleware: getMiddlewares(MockApi()),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: WidgetFilter(), store: store,));

    final usernameNew = "dfaf${Random().nextInt(10000)}";
    await tester.enterText(find.byType(TextField), usernameNew);
    await tester.tap(find.byKey(Key(sortbyKeyWillTap)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key(orderKeyWillTap)));
    await tester.tap(find.byKey(Key(WidgetKeys.btnCancelUpdateFilters)));
    await tester.pumpAndSettle();

    expect(selectorFilters(store.state), _filters);
  });

  testWidgets('WidgetFilter will not trigger ActionUpdateFilters even if pressing the confirm button in this page, when the filters does not change.', (WidgetTester tester) async {
    final _sortby = Random().nextBool()?QuerySortBy.TIME:QuerySortBy.USER;
    final _order = Random().nextBool()?QuerySortOrder.ASCENDING:QuerySortOrder.DESCENDING;
    final _filters = Filters(sortby: _sortby, order: _order);

    final state = AppState(filters: _filters);
    var store = Store<AppState>(
      appReducer,
      initialState: state,
      middleware: getMiddlewares(MockApi()),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: WidgetFilter(), store: store,));

    await tester.tap(find.byKey(Key(WidgetKeys.btnConfirmUpdateFilters)));
    await tester.pumpAndSettle();

    // ActionUpdateFilters will cause the filters to be updated within a pure function
    // so we could check whether two filters refer to the same object, with which we could 
    // infer whether ActionUpdateFilters is triggered.
    expect(identical(selectorFilters(store.state), _filters), isTrue);
  });

  testWidgets('Radio button username should be disabled if filtering with username.', (WidgetTester tester) async {

    final state = AppState(filters: Filters(username: "xx"));
    var store = Store<AppState>(
      appReducer,
      initialState: state,
      middleware: getMiddlewares(MockApi()),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: WidgetFilter(), store: store,));

    await tester.tap(find.byKey(Key(WidgetKeys.radioSortbyUsername)));
    await tester.tap(find.byKey(Key(WidgetKeys.btnConfirmUpdateFilters)));
    await tester.pumpAndSettle();

    expect(selectorFilters(store.state).sortby, QuerySortBy.NONE);
    expect(selectorFilters(store.state).order, null);
  });


  testWidgets('Radio buttons of the sort order group will be disabled if sort by none.', (WidgetTester tester) async {
    // order group
    final orderRandom = Random().nextBool();
    final orderKeyWillTap = orderRandom?WidgetKeys.radioOrderAscending:WidgetKeys.radioOrderDescending;

    final state = AppState(filters: Filters(sortby: QuerySortBy.NONE));
    var store = Store<AppState>(
      appReducer,
      initialState: state,
      middleware: getMiddlewares(MockApi()),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: WidgetFilter(), store: store,));

    await tester.tap(find.byKey(Key(orderKeyWillTap)));
    await tester.tap(find.byKey(Key(WidgetKeys.btnConfirmUpdateFilters)));
    await tester.pumpAndSettle();

    expect(selectorFilters(store.state).sortby, QuerySortBy.NONE);
    expect(selectorFilters(store.state).order, null);
  });
}