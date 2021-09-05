import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instapic/misc/config.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/middlewares/middlewares.dart';
import 'package:instapic/redux/reducers/reducers.dart';
import 'package:instapic/ui/keys.dart';
import 'package:instapic/ui/widgets/post_uploader_widget.dart';
import 'package:redux/redux.dart';
import '../../redux/middlewares/middlewares_fetch_posts_test.mocks.dart';
import '../ui_base_for_testing.dart';

void main() {
  testWidgets('WidgetUploader has some controls which users can interact with.', (WidgetTester tester) async {
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    await tester.pumpWidget(ScaffoldBase(testWidget: WidgetUploader(), store: store,));
    expect(find.byType(TextField), findsNWidgets(1));
    expect(find.byType(ElevatedButton), findsNWidgets(1));
    expect(find.byType(FloatingActionButton), findsNWidgets(2));
  });

  testWidgets('WidgetUploader should load the image after a local image is selected.', (WidgetTester tester) async {
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    final widget = WidgetUploader();
    await tester.pumpWidget(ScaffoldBase(testWidget: SingleChildScrollView(child: widget), store: store,));

    /// As testing of file picker is quite complicated, we try to mimic the selecting and loading of the image by directly
    /// calling the method [onChooseTheImage] of the state of [WidgetUploader].
    final stateOfWidget = tester.state(find.byWidget(widget)) as WidgetUploaderState;

    final filePath = "test_data/images/size_reasonable.jpg";
    final imageBytes = (await rootBundle.load(filePath)).buffer.asUint8List();

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
  });

  testWidgets('WidgetUploader should only render the image whose size is less than ${Config.MAX_PICTURE_SIZE_BYTE}', (WidgetTester tester) async {
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    final widget = WidgetUploader();
    await tester.pumpWidget(ScaffoldBase(testWidget: SingleChildScrollView(child: widget), store: store,));

    /// As testing of file picker is quite complicated, we try to mimic the selecting and loading of the image by directly
    /// calling the method [onChooseTheImage] of the state of [WidgetUploader].
    final stateOfWidget = tester.state(find.byWidget(widget)) as WidgetUploaderState;

    final filePath = "test_data/images/oversize.jpg";
    final imageBytes = (await rootBundle.load(filePath)).buffer.asUint8List();

    stateOfWidget.onChooseTheImage(
      PlatformFile(
        name: filePath.split("/").last,
        size: imageBytes.length,
        path: filePath,
        bytes: imageBytes
    ));

    await tester.pumpAndSettle();

    expect(find.text("The size of the file should be less than ${Config.MAX_PICTURE_SIZE_BYTE} bytes!"), findsNWidgets(1));
    // consider that the dialog will persist for 10 seconds, so
    // we wait 11 seconds till the dialog disappears
    await tester.pumpAndSettle(Duration(seconds: 11));
    expect(find.text("The size of the file should be less than ${Config.MAX_PICTURE_SIZE_BYTE} bytes!"), findsNWidgets(0));

    /// the image should show up in this widget
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('WidgetUploader should prompt "Please select an image!" if we have not choosen the image when clicing on the "Upload" button.', (WidgetTester tester) async {
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    final widget = WidgetUploader();
    await tester.pumpWidget(ScaffoldBase(testWidget: SingleChildScrollView(child: widget), store: store,));

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(WidgetKeys.btnConfirmUpload)));
    await tester.pumpAndSettle();

    expect(find.text("Please select an image!"), findsNWidgets(1));
    // consider that the dialog will persist for 10 seconds, so
    // we wait 11 seconds till the dialog disappears
    await tester.pumpAndSettle(Duration(seconds: 11));
    expect(find.text("Please select an image!"), findsNWidgets(0));
  });

  testWidgets('WidgetUploader should prompt "Please enter the description!"" if we have not entered anything in the TextField.', (WidgetTester tester) async {
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    final widget = WidgetUploader();
    await tester.pumpWidget(ScaffoldBase(testWidget: SingleChildScrollView(child: widget), store: store,));

    /// As testing of file picker is quite complicated, we try to mimic the selecting and loading of the image by directly
    /// calling the method [onChooseTheImage] of the state of [WidgetUploader].
    final stateOfWidget = tester.state(find.byWidget(widget)) as WidgetUploaderState;

    final filePath = "test_data/images/size_reasonable.jpg";
    final imageBytes = (await rootBundle.load(filePath)).buffer.asUint8List();

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

    await tester.drag(find.byWidget(widget), const Offset(0, -200));
    await tester.tap(find.byKey(Key(WidgetKeys.btnConfirmUpload)));
    await tester.pumpAndSettle();

    expect(find.text("Please enter the description!"), findsNWidgets(1));
    // consider that the dialog will persist for 10 seconds, so
    // we wait 11 seconds till the dialog disappears
    await tester.pumpAndSettle(Duration(seconds: 11));
    expect(find.text("Please enter the description!"), findsNWidgets(0));
  });

  testWidgets('WidgetUploader should prompt "Please enter at least 20 characters for the description!" if the description chars are less than 20.', (WidgetTester tester) async {
    var store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: getMiddlewares(MockApi()),
    );
    final widget = WidgetUploader();
    await tester.pumpWidget(ScaffoldBase(testWidget: SingleChildScrollView(child: widget), store: store,));

    /// As testing of file picker is quite complicated, we try to mimic the selecting and loading of the image by directly
    /// calling the method [onChooseTheImage] of the state of [WidgetUploader].
    final stateOfWidget = tester.state(find.byWidget(widget)) as WidgetUploaderState;

    final filePath = "test_data/images/size_reasonable.jpg";
    final imageBytes = (await rootBundle.load(filePath)).buffer.asUint8List();

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

    await tester.enterText(find.byType(TextField), "xxxx");

    await tester.drag(find.byWidget(widget), const Offset(0, -200));
    await tester.tap(find.byKey(Key(WidgetKeys.btnConfirmUpload)));
    await tester.pumpAndSettle();

    expect(find.text("Please enter at least 20 characters for the description!"), findsNWidgets(1));
    // consider that the dialog will persist for 10 seconds, so
    // we wait 11 seconds till the dialog disappears
    await tester.pumpAndSettle(Duration(seconds: 11));
    expect(find.text("Please enter at least 20 characters for the description!"), findsNWidgets(0));
  });
}