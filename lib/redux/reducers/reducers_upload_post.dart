import 'package:instapic/models/upload_status.dart';
import 'package:instapic/redux/actions/action_upload_post.dart';
import 'package:redux/redux.dart';

final reducersPostingStatus = combineReducers<UploadStatus>([
  TypedReducer<UploadStatus, ActionUploadPost>(_reducerPosting),
  TypedReducer<UploadStatus, ActionUploadPostSucceeded>(_reducerPostingSucceeded),
  TypedReducer<UploadStatus, ActionUploadPostFailed>(_reducerPostingFailed)
]);

UploadStatus _reducerPosting(UploadStatus status, ActionUploadPost action) {
  return UploadStatus(isPosting: true, isSucceeded: null);
}

UploadStatus _reducerPostingSucceeded(UploadStatus status, ActionUploadPostSucceeded action) {
  return UploadStatus(isPosting: false, isSucceeded: true);
}

UploadStatus _reducerPostingFailed(UploadStatus status, ActionUploadPostFailed action) {
  return UploadStatus(isPosting: false, isSucceeded: false);
}
