import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/remote/api.dart';
import 'package:instapic/ui/pages/page_base.dart';
import 'package:redux/redux.dart';
import 'ui/dialogs/prompt_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';

void main() {
  configureApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // initilize the prompt dialogs, so that the stream for showing dialogs
    // is listened.
    PromptDialogs();
    return StoreProvider<AppState>(
      store: Store<AppState>(
        appReducer,
        initialState: AppState(),
        middleware: getMiddlewares(Api()),
      ),
      child: MaterialApp(
        // navigatorKey: GlobalWidgets.navigatorKey,
        debugShowCheckedModeBanner: false,
        // initialRoute: RouteNames.login,
        // routes: routes,
        title: 'InstaPic',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        builder: EasyLoading.init(),
        home: PageBase(),
      ),
    );
  }
}

