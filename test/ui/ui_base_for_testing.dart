import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/ui/dialogs/prompt_dialogs.dart';
import 'package:redux/redux.dart';

class ScaffoldBase extends StatelessWidget {
  ScaffoldBase({required this.testWidget, required this.store, Key? key}) : 
    super(key: key);
  final Widget testWidget;
  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    PromptDialogs();
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: "Base Scaffold for testing",
        builder: EasyLoading.init(),
        home: Scaffold(
          body: Center(
            child: testWidget,
          ),
        ),
      ),
    );
  }
}