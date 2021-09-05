import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/ui/dialogs/prompt_dialogs.dart';
import 'package:redux/redux.dart';
import '../../redux/middlewares/middlewares_fetch_posts_test.mocks.dart';
import '../ui_base_for_testing.dart';

void main() {
  testWidgets('A call to [showErrorAsync] should display an error prompt.',
      (WidgetTester tester) async {
    final msg = Random().nextInt(10000).toString();
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    final btn = TextButton(
      onPressed: () {
        PromptDialogs.showErrorAsync(msg);
      },
      child: Container(),
    );
    await tester.pumpWidget(ScaffoldBase(
      testWidget: btn,
      store: store,
    ));
    await tester.tap(find.byWidget(btn));

    // By default this dialog will exist for 10 seconds, so :
    await tester.pump(Duration(seconds: 1));
    expect(find.text(msg), findsNWidgets(1));
    await EasyLoading.dismiss(animation: false);
    await tester.pump(Duration(seconds: 1));
    expect(find.text(msg), findsNothing);
  });

  testWidgets('A call to [showError] should display an error prompt.',
      (WidgetTester tester) async {
    final msg = Random().nextInt(10000).toString();
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    final btn = TextButton(
      onPressed: () {
        PromptDialogs.showError(msg);
      },
      child: Container(),
    );
    await tester.pumpWidget(ScaffoldBase(
      testWidget: btn,
      store: store,
    ));
    await tester.tap(find.byWidget(btn));

    // By default this dialog will exist for 10 seconds, so :
    await tester.pump(Duration(seconds: 1));
    expect(find.text(msg), findsNWidgets(1));
    await EasyLoading.dismiss(animation: false);
    await tester.pump(Duration(seconds: 1));
    expect(find.text(msg), findsNothing);
  });

  testWidgets('A call to [showInfo] should display an error prompt.',
      (WidgetTester tester) async {
    final msg = Random().nextInt(10000).toString();
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    final btn = TextButton(
      onPressed: () {
        PromptDialogs.showInfo(msg);
      },
      child: Container(),
    );
    await tester.pumpWidget(ScaffoldBase(
      testWidget: btn,
      store: store,
    ));
    await tester.tap(find.byWidget(btn));

    // By default this dialog will exist for 10 seconds, so :
    await tester.pump(Duration(seconds: 1));
    expect(find.text(msg), findsNWidgets(1));
    await EasyLoading.dismiss(animation: false);
    await tester.pump(Duration(seconds: 1));
    expect(find.text(msg), findsNothing);
  });

  testWidgets('A call to [showSuccess] should display an error prompt.',
      (WidgetTester tester) async {
    final msg = Random().nextInt(10000).toString();
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    final btn = TextButton(
      onPressed: () {
        PromptDialogs.showSuccess(msg: msg);
      },
      child: Container(),
    );
    await tester.pumpWidget(ScaffoldBase(
      testWidget: btn,
      store: store,
    ));
    await tester.tap(find.byWidget(btn));

    // By default this dialog will exist for 10 seconds, so :
    await tester.pump(Duration(seconds: 1));
    expect(find.text(msg), findsNWidgets(1));
    await EasyLoading.dismiss(animation: false);
    await tester.pump(Duration(seconds: 1));
    expect(find.text(msg), findsNothing);
  });

  testWidgets('A call to [showProgress] should display an error prompt.',
      (WidgetTester tester) async {
    final msg = Random().nextInt(10000).toString();
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    final btn = TextButton(
      onPressed: () {
        PromptDialogs.showProgress(0, status: msg);
      },
      child: Container(),
    );
    await tester.pumpWidget(ScaffoldBase(
      testWidget: btn,
      store: store,
    ));
    await tester.tap(find.byWidget(btn));

    // By default this dialog will exist for 10 seconds, so :
    await tester.pump(Duration(seconds: 1));
    expect(find.text(msg), findsNWidgets(1));
    await EasyLoading.dismiss(animation: false);
    await tester.pump(Duration(seconds: 1));
    expect(find.text(msg), findsNothing);
  });
}
