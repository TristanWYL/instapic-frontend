import 'package:instapic/ui/dialogs/prompt_dialogs.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/actions/action_others.dart';
import 'package:redux/redux.dart';

class MiddlewaresOther{
  List<Middleware<AppState>> getMiddlewares(){
    return [_errorAlert];
  }
  void _errorAlert(Store<AppState> store, action, NextDispatcher next){
    if(action is ActionPromptError){
      // the forwarding of this action will simply stop here
      // by showing an alert window for prompting
      // PromptDialogs.showError(action.error);
      PromptDialogs.showErrorAsync(action.error);
      return;
    }
    // Make sure our actions continue on to the reducer.
    next(action);
  }
}