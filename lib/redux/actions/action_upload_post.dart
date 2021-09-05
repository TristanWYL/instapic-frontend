import 'dart:typed_data';

class ActionUploadPost{
  final String description;
  final Uint8List imageBytes;
  final String imageFileName;
  void Function(int, int)? onSendProgress;

  ActionUploadPost({required this.description, required this.imageBytes, required this.imageFileName, this.onSendProgress});
}

class ActionUploadPostSucceeded{}
class ActionUploadPostFailed{}
