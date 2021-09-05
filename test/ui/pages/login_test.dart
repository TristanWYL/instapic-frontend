// As the UI is basically tested in the widget test part
// here we mainly test the working of the business logic of this page
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:instapic/remote/response.dart';
import 'package:instapic/ui/keys.dart';
import 'package:instapic/ui/pages/login.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import '../../redux/middlewares/middlewares_fetch_posts_test.mocks.dart';
import '../ui_base_for_testing.dart';

void main() {
  final username = "xxxxxx";
  final password = "xeagaweagsb";

  testWidgets('Login page will check login status when loading and it is logged in.', (WidgetTester tester) async {
    var api = MockApi();

    final mockResponseWithLogin = ApiResponse(200, "Have logged in.", data:{
            "login":true,
            "username":username
        });
    when(api.signInQuery()).thenAnswer((_) => Future.value(mockResponseWithLogin));

    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(api),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: PageLogin(), store: store,));
    
    await untilCalled(api.signInQuery());
    verify(api.signInQuery()).called(1);

    expect(selectorIsLogin(selectorLoginStatus(store.state)), true);
    expect(selectorUsername(selectorLoginStatus(store.state)), username);
  });

  testWidgets('Login page will check login status when loading and it is not logged in.', (WidgetTester tester) async {
    final api = MockApi();
    final mockResponseWithoutLogin = ApiResponse(200, "Not logged in yet.", data:{
            "login":false,
            "username":null
        });
    when(api.signInQuery()).thenAnswer((_) => Future.value(mockResponseWithoutLogin));

    final store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(api),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: PageLogin(), store: store,));
    
    await untilCalled(api.signInQuery());
    verify(api.signInQuery()).called(1);
    expect(selectorIsLogin(selectorLoginStatus(store.state)), false);
  });

  testWidgets('Login page will try to login when submitting the login form, and login successfully.', (WidgetTester tester) async {
    var api = MockApi();
    final mockResponseWithoutLogin = ApiResponse(200, "Not logged in yet.", data:{
            "login":false,
            "username":null
        });
    when(api.signInQuery()).thenAnswer((_) => Future.value(mockResponseWithoutLogin));

    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(api),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: PageLogin(), store: store,));
    
    var mockResponse = ApiResponse(200, "Login successfully");
    when(api.signIn(username, password)).thenAnswer((_) => Future.value(mockResponse));

    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldUsername)), username);
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldPassword)), password);
    await tester.tap(find.byType(ElevatedButton));

    await untilCalled(api.signIn(username, password));
    verify(api.signIn(username, password)).called(1);
    expect(selectorIsLogin(selectorLoginStatus(store.state)), true);
    expect(selectorUsername(selectorLoginStatus(store.state)), username);
  });

  testWidgets('Login page will try to login when submitting the login form, and login failed.', (WidgetTester tester) async {
    final api = MockApi();
    final mockResponseWithoutLogin = ApiResponse(200, "Not logged in yet.", data:{
            "login":false,
            "username":null
        });
    when(api.signInQuery()).thenAnswer((_) => Future.value(mockResponseWithoutLogin));

    final store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(api),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: PageLogin(), store: store,));

    final msg = "Failed to login!";
    final mockResponse = ApiResponse(400, msg);
    when(api.signIn(username, password)).thenAnswer((_) => Future.value(mockResponse));

    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldUsername)), username);
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldPassword)), password);
    await tester.tap(find.byType(ElevatedButton));

    await untilCalled(api.signIn(username, password));
    verify(api.signIn(username, password)).called(1);
    expect(selectorIsLogin(selectorLoginStatus(store.state)), false);

    // check the prompt dialog
    await EasyLoading.dismiss(animation: false);
    await tester.pump(Duration(seconds: 1));
    expect(find.text(msg), findsNothing);
  });

  testWidgets('Login page will try to sign up when submitting the sign-up form and sign up successfully.', (WidgetTester tester) async {
    final api = MockApi();
    final mockResponseWithoutLogin = ApiResponse(200, "Not logged in yet.", data:{
            "login":false,
            "username":null
        });
    when(api.signInQuery()).thenAnswer((_) => Future.value(mockResponseWithoutLogin));

    final store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(api),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: PageLogin(), store: store,));

    final mockResponseSignUp = ApiResponse(200, "Sign up successfully");
    when(api.signUp(username, password)).thenAnswer((_) => Future.value(mockResponseSignUp));
    var mockResponseSignIn = ApiResponse(200, "Login successfully");
    when(api.signIn(username, password)).thenAnswer((_) => Future.value(mockResponseSignIn));
    // switch the form from signin to signup
    expect(find.byType(TextButton), findsOneWidget);
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsNWidgets(3));

    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldUsername)), username);
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldPassword)), password);
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldPasswordConfirm)), password);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    await untilCalled(api.signUp(username, password));
    verify(api.signUp(username, password)).called(1);
    await untilCalled(api.signIn(username, password));
    verify(api.signIn(username, password)).called(1);
  });

  testWidgets('Login page will try to sign up when submitting the sign-up form and sign-up failed for some reasons.', (WidgetTester tester) async {
    final api = MockApi();
    final mockResponseWithoutLogin = ApiResponse(200, "Not logged in yet.", data:{
            "login":false,
            "username":null
        });
    when(api.signInQuery()).thenAnswer((_) => Future.value(mockResponseWithoutLogin));

    final store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(api),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: PageLogin(), store: store,));

    final mockResponseSignUp = ApiResponse(400, "Failed to sign up.");
    when(api.signUp(username, password)).thenAnswer((_) => Future.value(mockResponseSignUp));

    // switch from signin to signup
    expect(find.byType(TextButton), findsOneWidget);
    await tester.tap(find.byType(TextButton, skipOffstage: false));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField, skipOffstage: false), findsNWidgets(3));

    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldUsername)), username);
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldPassword)), password);
    await tester.enterText(find.byKey(Key(WidgetKeys.textFieldPasswordConfirm)), password);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    await untilCalled(api.signUp(username, password));
    verify(api.signUp(username, password)).called(1);
  });
}