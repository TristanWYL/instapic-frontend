import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/login_status.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/ui/keys.dart';
import 'package:instapic/ui/widgets/login_widget.dart';
import 'package:redux/redux.dart';
import '../../redux/middlewares/middlewares_fetch_posts_test.mocks.dart';
import '../ui_base_for_testing.dart';

void main() {
  final username = "xxxxxx";
  final password = "xeagaweagsb";

  testWidgets('WidgetSign has one view for Sign in.', (WidgetTester tester) async {

    // refer to https://stackoverflow.com/questions/53706569/how-to-test-flutter-widgets-on-different-screen-sizes/53707065#53707065
    // tester.binding.window.physicalSizeTestValue = Size(1920, 1080);
    // tester.binding.window.devicePixelRatioTestValue = 2;

    // // resets the screen to its orinal size after the test end
    // addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: WidgetSign(), store: store,));
    
    expect(find.byType(TextFormField), findsNWidgets(2));

    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldUsername)), username);
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldPassword)), password);

    expect(find.text(username), findsOneWidget);
    expect(find.text(password), findsOneWidget);
    expect(find.text("Sign In"), findsOneWidget);
    expect(find.text("Submit"), findsOneWidget);
    expect(find.text("Sign Up?"), findsOneWidget);
  });

  testWidgets('WidgetSign has another view for Sign up.', (WidgetTester tester) async {
    final state = AppState(loginStatus: LoginStatus(isLogin: true, username: username));
    var store = Store<AppState>(
      appReducer,
      initialState: state,
      middleware: getMiddlewares(MockApi()),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: WidgetSign(), store: store,));
    expect(find.byType(TextFormField), findsNWidgets(2));

    // switch from signin to signup
    expect(find.byType(TextButton), findsOneWidget);
    await tester.tap(find.byType(TextButton, skipOffstage: false));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField, skipOffstage: false), findsNWidgets(3));

    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldUsername)), username);
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldPassword)), password);
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldPasswordConfirm)), password);

    expect(find.text(username), findsOneWidget);
    expect(find.text(password), findsNWidgets(2));
    expect(find.text("Sign Up"), findsOneWidget);
    expect(find.text("Submit"), findsOneWidget);
    expect(find.text("Sign In?"), findsOneWidget);
  });

  testWidgets('WidgetSign validation for the input.', (WidgetTester tester) async {
    final state = AppState(loginStatus: LoginStatus(isLogin: true, username: username));
    var store = Store<AppState>(
      appReducer,
      initialState: state,
      middleware: getMiddlewares(MockApi()),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: WidgetSign(), store: store,));
    expect(find.byType(TextFormField), findsNWidgets(2));
    // validation for the signin form
    var usernameInvalid = "?daeg%";
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldUsername)), usernameInvalid);
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldPassword)), password);
    expect(find.byType(ElevatedButton), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton, skipOffstage: false));
    await tester.pumpAndSettle();
    expect(find.text("Username can only include alphanumeric characters!"), findsOneWidget);

    usernameInvalid = "";
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldUsername)), usernameInvalid);
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldPassword)), password);
    expect(find.byType(ElevatedButton), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton, skipOffstage: false));
    await tester.pumpAndSettle();
    expect(find.text("Please enter your username!"), findsOneWidget);

    var passwordInvalid = "";
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldUsername)), username);
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldPassword)), passwordInvalid);
    expect(find.byType(ElevatedButton), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton, skipOffstage: false));
    await tester.pumpAndSettle();
    expect(find.text("Please enter your password!"), findsOneWidget);

    

    // validation for the signup form
    // switch from signin to signup
    expect(find.byType(TextButton), findsOneWidget);
    await tester.tap(find.byType(TextButton, skipOffstage: false));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField, skipOffstage: false), findsNWidgets(3));

    passwordInvalid = "ga#45 %gn";
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldUsername)), username);
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldPassword)), passwordInvalid);
    expect(find.byType(ElevatedButton), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton, skipOffstage: false));
    await tester.pumpAndSettle();
    expect(find.text("Cannot include whitespaces anywhere!"), findsOneWidget);
    expect(find.text("Please confirm your password!"), findsOneWidget);

    var passwordConfirm = "hfd";
    expect(password==passwordConfirm, false);
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldUsername)), username);
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldPassword)), password);
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldPasswordConfirm)), passwordConfirm);
    expect(find.byType(ElevatedButton), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton, skipOffstage: false));
    await tester.pumpAndSettle();
    expect(find.text("Password confirmation failed!"), findsOneWidget);
  });
}