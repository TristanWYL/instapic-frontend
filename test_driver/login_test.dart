import 'package:flutter_driver/flutter_driver.dart';
import 'package:instapic/ui/keys.dart';
import 'package:test/test.dart';

void loginTest() {
  group('Login Testing: ', () {
    final textFunction = find.byValueKey(WidgetKeys.textFunction);
    final textFieldUsername = find.byValueKey(WidgetKeys.textFieldUsername);
    final textFieldPassword = find.byValueKey(WidgetKeys.textFieldPassword);
    final btnSubmit = find.byValueKey(WidgetKeys.btnSubmit);
    final btnSignInUpSwitch = find.byValueKey(WidgetKeys.btnSignInUpSwitch);
    
    late FlutterDriver driver;

    final usernameRegistered = "Felicia";
    final pwRegistered = "felicia";

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });

    test('sign in/up switching', () async {
      expect(await driver.getText(textFunction), "Sign In");
      await driver.tap(btnSignInUpSwitch);
      expect(await driver.getText(textFunction), "Sign Up");
    });

    test('sign up testing', () async {
      if(await driver.getText(textFunction) == "Sign In"){
        await driver.tap(btnSignInUpSwitch);
      }
      expect(await driver.getText(textFunction), "Sign Up");
    });


    test('sign in testing', () async {
      if(await driver.getText(textFunction) == "Sign Up"){
        await driver.tap(btnSignInUpSwitch);
      }
      expect(await driver.getText(textFunction), "Sign In");
      
      // enter username
      await driver.tap(textFieldUsername);
      await driver.enterText(usernameRegistered);
      await driver.waitFor(find.text(usernameRegistered));

      // enter password
      await driver.tap(textFieldPassword);
      await driver.enterText(pwRegistered);
      await driver.waitFor(find.text(pwRegistered));

      // click on Submit
      await driver.tap(btnSubmit);

      // verify this is the browse page
      // driver.get
    });
  });
}