// test the page switch
// test the api interaction

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:instapic/remote/response.dart';
import 'package:instapic/ui/keys.dart';
import 'package:instapic/ui/pages/upload.dart';
import 'package:instapic/ui/routes.dart';
import 'package:instapic/ui/widgets/post_uploader_widget.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import '../../redux/middlewares/middlewares_fetch_posts_test.mocks.dart';
import '../ui_base_for_testing.dart';

void main() {
  testWidgets('PageUpload should be directed to browse page when it is cancelled.', (WidgetTester tester) async {
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    final widget = PageUpload(pageID: 3,);
    await tester.pumpWidget(ScaffoldBase(testWidget: widget, store: store,));

    await tester.tap(find.byKey(Key(WidgetKeys.btnCancelUpload)));
    await tester.pumpAndSettle();

    expect(selectorCurrentRoute(store.state), RouteNames.browse);
  });

  testWidgets('PageUpload uploads the image successfully.', (WidgetTester tester) async {
    final filePath = "test_data/images/size_reasonable.jpg";
    final imageBytes = (await rootBundle.load(filePath)).buffer.asUint8List();
    final description = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";

    final api = MockApi();
    final mockResponse = ApiResponse(200, "Post successfully");
    when(api.post(imageBytes, description, any, onSendProgress: anyNamed("onSendProgress"))).thenAnswer((_) => Future.value(mockResponse));
    
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(api),
    );
    final widget = PageUpload(pageID: 3,);
    await tester.pumpWidget(ScaffoldBase(testWidget: widget, store: store,));

    /// As testing of file picker is quite complicated, we try to mimic the selecting and loading of the image by directly
    /// calling the method [onChooseTheImage] of the state of [WidgetUploader].
    final stateOfWidget = tester.state(find.byType(WidgetUploader)) as WidgetUploaderState;

    stateOfWidget.onChooseTheImage(
      PlatformFile(
        name: filePath.split("/").last,
        size: imageBytes.length,
        path: filePath,
        bytes: imageBytes
    ));

    await tester.pumpAndSettle();
    /// the image should show up in this widget
    expect(find.byType(Image), findsNWidgets(1));

    await tester.enterText(find.byType(TextField), description);

    await tester.drag(find.byWidget(widget), const Offset(0, -220));
    await tester.tap(find.byKey(Key(WidgetKeys.btnConfirmUpload)));
    
    await untilCalled(api.post(imageBytes, description, any, onSendProgress: anyNamed("onSendProgress")));
    verify(api.post(imageBytes, description, any, onSendProgress: anyNamed("onSendProgress"))).called(1);

    expect(selectorIsPosting(store.state), isFalse);
    expect(selectorUploadSucceeded(store.state), isTrue);
    
    stateOfWidget.fileUploaded = true;
    // this pump is for executing the actioni of popping up the dialog
    await tester.pump();

    // this pump is for rendering the dialog
    await tester.pumpAndSettle(Duration(seconds: 1));

    expect(find.text("Success"), findsNWidgets(1));
    // consider that the dialog will persist for 2 seconds, so
    // we wait 3 seconds till the dialog disappears
    await tester.pumpAndSettle(Duration(seconds: 3));
    expect(find.text("Success"), findsNWidgets(0));
  });

  testWidgets('PageUpload failed to upload the image for some reasons.', (WidgetTester tester) async {
    final filePath = "test_data/images/size_reasonable.jpg";
    final imageBytes = (await rootBundle.load(filePath)).buffer.asUint8List();
    final description = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";

    final api = MockApi();
    final msg = "Any reasons";
    final mockResponse = ApiResponse(400, msg);
    when(api.post(imageBytes, description, any, onSendProgress: anyNamed("onSendProgress"))).thenAnswer((_) => Future.value(mockResponse));
    
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(api),
    );
    final widget = PageUpload(pageID: 3,);
    await tester.pumpWidget(ScaffoldBase(testWidget: widget, store: store,));

    /// As testing of file picker is quite complicated, we try to mimic the selecting and loading of the image by directly
    /// calling the method [onChooseTheImage] of the state of [WidgetUploader].
    final stateOfWidget = tester.state(find.byType(WidgetUploader)) as WidgetUploaderState;

    

    stateOfWidget.onChooseTheImage(
      PlatformFile(
        name: filePath.split("/").last,
        size: imageBytes.length,
        path: filePath,
        bytes: imageBytes
    ));

    await tester.pumpAndSettle();
    /// the image should show up in this widget
    expect(find.byType(Image), findsNWidgets(1));

    await tester.enterText(find.byType(TextField), description);

    await tester.drag(find.byWidget(widget), const Offset(0, -220));
    await tester.tap(find.byKey(Key(WidgetKeys.btnConfirmUpload)));

    await untilCalled(api.post(imageBytes, description, any, onSendProgress: anyNamed("onSendProgress")));
    verify(api.post(imageBytes, description, any, onSendProgress: anyNamed("onSendProgress"))).called(1);

    expect(selectorIsPosting(store.state), isFalse);
    expect(selectorUploadSucceeded(store.state), isFalse);

    // this pump is for rendering the dialog
    await tester.pumpAndSettle(Duration(seconds: 1));
    expect(find.text(msg), findsNWidgets(1));
    await EasyLoading.dismiss(animation: false);
    await tester.pump(Duration(seconds: 1));
    expect(find.text(msg), findsNothing);
  });
}