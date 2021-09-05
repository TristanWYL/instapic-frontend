import 'dart:typed_data';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/actions/action_upload_post.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:instapic/remote/api.dart';
import 'package:instapic/remote/response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';
import 'middlewares_fetch_posts_test.mocks.dart';

@GenerateMocks([Api])
void main() {
  group("Middlewares testing for Uploading Posts:", () {

    test("uploading posts successfully", () async {
      final api = MockApi();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(),
        middleware: getMiddlewares(api),
      );

      
      final mockResponse = ApiResponse(200, "Post successfully");

      when(api.post(any, any, any)).thenAnswer((_) => Future.value(mockResponse));

      store.dispatch(ActionUploadPost(description: "description", imageBytes: Uint8List(1), imageFileName: "imageFileName"));

      await untilCalled(api.post(any, any, any));
      verify(api.post(any, any, any)).called(1);

      expect(selectorUploadSucceeded(store.state), true);
      expect(selectorIsPosting(store.state), false);
    });

    test("failed to upload posts", () async {
      final api = MockApi();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(),
        middleware: getMiddlewares(api),
      );

      
      final mockResponse = ApiResponse(400, "Failed");

      when(api.post(any, any, any)).thenAnswer((_) => Future.value(mockResponse));

      store.dispatch(ActionUploadPost(description: "description", imageBytes: Uint8List(1), imageFileName: "imageFileName"));

      await untilCalled(api.post(any, any, any));
      verify(api.post(any, any, any)).called(1);

      expect(selectorUploadSucceeded(store.state), false);
      expect(selectorIsPosting(store.state), false);
    });
  });
}
