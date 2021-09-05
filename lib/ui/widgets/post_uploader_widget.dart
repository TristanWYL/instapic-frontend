import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:instapic/misc/config.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/actions/action_navigation.dart';
import 'package:instapic/redux/actions/action_upload_post.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:instapic/ui/dialogs/prompt_dialogs.dart';
import 'package:instapic/ui/keys.dart';
import 'package:instapic/ui/routes.dart';
import 'package:redux/redux.dart';

class WidgetUploader extends StatefulWidget {
  WidgetUploader({Key? key}) : super(key: key);

  @override
  _WidgetUploaderState createState() => _WidgetUploaderState();
}

class _WidgetUploaderState extends State<WidgetUploader> {
  String? _filePath;
  String? _desription;
  Uint8List? _image;
  bool fileUploaded = false;

  void onChooseTheImage(PlatformFile file) {
    if (file.bytes!.length > Config.MAX_PICTURE_SIZE_BYTE) {
      PromptDialogs.showError(
          "The size of the file should be less than ${Config.MAX_PICTURE_SIZE_BYTE} bytes!");
      return;
    }

    setState(() {
      _filePath = file.name;
      _image = file.bytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "STEP 1: Choose the image file:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 30),
          child: Text(
            "Image size should be less than ${Config.MAX_PICTURE_SIZE_BYTE} bytes.",
            style: TextStyle(color: Colors.green),
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform
                  .pickFiles(type: FileType.image, allowMultiple: false);
              if (result?.files.first != null) {
                onChooseTheImage(result!.files.first);
              }
            },
            child: Text("Choose the image:")),
        _filePath == null
            ? SizedBox()
            : Image.memory(_image!,
                width: 600, height: 400, fit: BoxFit.contain),
        _filePath == null ? SizedBox() : Text(_filePath!),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: null,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "STEP 2: Enter the description:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: SizedBox(
            width: 400,
            child: TextField(
              obscureText: false,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "The description of this image"),
              onChanged: (value) {
                _desription = value;
              },
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        StoreConnector<AppState, _ViewModel>(
            converter: _ViewModel.fromStore,
            builder: (context, vm) {
              if (fileUploaded) {
                vm.onSuccessUpload();
                fileUploaded = false;
              }
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    key: Key(WidgetKeys.btnConfirmUpload),
                    heroTag: null,
                    onPressed: () {
                      if (_image == null) {
                        PromptDialogs.showInfo("Please select an image!");
                        return;
                      }
                      if (_desription == null || _desription?.trim() == "") {
                        PromptDialogs.showInfo("Please enter the description!");
                        return;
                      }
                      if (_desription!.trim().length < 20) {
                        PromptDialogs.showInfo(
                            "Please enter at least 20 characters for the description!");
                        return;
                      }

                      vm.onConfirmUpload(ActionUploadPost(
                          description: _desription!,
                          imageBytes: _image!,
                          imageFileName: _filePath!,
                          onSendProgress: (count, total) async {
                            double _progress = count / total;
                            PromptDialogs.showProgress(_progress,
                                status:
                                    "${(_progress * 100).toStringAsFixed(0)}%");
                            if (count >= total) {
                              fileUploaded = true;
                            }
                          }));
                    },
                    child: const Icon(Icons.check),
                    backgroundColor: Colors.green,
                    tooltip: "Upload",
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  FloatingActionButton(
                    key: Key(WidgetKeys.btnCancelUpload),
                    onPressed: vm.onCancelUpload,
                    child: const Icon(Icons.cancel_outlined),
                    backgroundColor: Colors.red,
                    tooltip: "Cancel",
                  )
                ],
              );
            })
      ],
    );
  }
}

class _ViewModel {
  final Function(ActionUploadPost) onConfirmUpload;
  final Function() onCancelUpload;
  final Function() onSuccessUpload;

  _ViewModel(
      {required this.onConfirmUpload,
      required this.onCancelUpload,
      required this.onSuccessUpload});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(onConfirmUpload: (action) {
      if (!selectorIsPosting(store.state)) {
        store.dispatch(action);
      }
    }, onCancelUpload: () {
      store.dispatch(ActionNavigation(mapRouteDetails[RouteNames.browse]!));
    }, onSuccessUpload: () {
      var succeeded = selectorUploadSucceeded(store.state);
      if (succeeded == true) {
        PromptDialogs.showSuccess();
      }
    });
  }
}

typedef WidgetUploaderState = _WidgetUploaderState;
