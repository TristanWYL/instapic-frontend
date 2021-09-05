import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/actions/action_upload_post.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:redux/redux.dart';

void main() {
  group("Reducers for Uploading Posts", (){
    test("should change the state of 'isPosting' as 'true', in response to ActionUploadPost", (){
      final store = Store<AppState>(
        appReducer,
        initialState: AppState()
      );
      final action = ActionUploadPost(description: "", imageBytes: Uint8List.fromList([]), imageFileName: "1");
      store.dispatch(action);
      expect(selectorIsPosting(store.state), true);
      expect(selectorUploadSucceeded(store.state), null);
    });

    test("should change the state of 'isPosting' as 'false', in response to ActionUploadPostSucceeded", (){
      final store = Store<AppState>(
        appReducer,
        initialState: AppState()
      );
      final action = ActionUploadPostSucceeded();
      store.dispatch(action);
      expect(selectorIsPosting(store.state), false);
      expect(selectorUploadSucceeded(store.state), true);
    });

    test("should change the state of 'isPosting' as 'false', in response to ActionUploadPostFailed", (){
      final store = Store<AppState>(
        appReducer,
        initialState: AppState()
      );
      final action = ActionUploadPostFailed();
      store.dispatch(action);
      expect(selectorIsPosting(store.state), false);
      expect(selectorUploadSucceeded(store.state), false);
    });
  });
}