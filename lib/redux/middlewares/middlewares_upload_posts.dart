import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/actions/action_others.dart';
import 'package:instapic/redux/actions/action_upload_post.dart';
import 'package:instapic/remote/api.dart';
import 'package:instapic/remote/response.dart';
import 'package:redux/redux.dart';

class MiddlewaresUploadPost{
  final Api api;
  MiddlewaresUploadPost(this.api);

  List<Middleware<AppState>> getMiddlewares(){
      return [_uploadPost];
  }

  void _uploadPost(Store<AppState> store, action, NextDispatcher next){
    if(action is ActionUploadPost){
      api.post(action.imageBytes, action.description, action.imageFileName, onSendProgress: action.onSendProgress).then((apiResponse){
          if(apiResponse.code == ApiResponse.CODE_OK){
            store.dispatch(ActionUploadPostSucceeded());
          }else{
            store.dispatch(ActionUploadPostFailed());
            store.dispatch(ActionPromptError(apiResponse.msg));
          }
        });
    }
    // Make sure our actions continue on to the reducer.
    next(action);
  }
}