import 'package:instapic/models/fetch_posts_status.dart';
import 'package:instapic/models/filters.dart';
import 'package:instapic/models/login_status.dart';
import 'package:instapic/models/upload_status.dart';
import 'package:instapic/ui/routes.dart';

class AppState{
  final String currentRoute;
  final LoginStatus loginStatus;
  final Filters filters;
  final PostsFetchStatus postsFetchStatus;
  final UploadStatus uploadStatus;

  AppState({
    String? currentRoute,
    LoginStatus? loginStatus, 
    Filters? filters, 
    PostsFetchStatus? postsFetchStatus, 
    UploadStatus? uploadStatus}) :
    currentRoute = currentRoute ?? RouteNames.login,
    loginStatus = loginStatus ?? LoginStatus(),
    filters = filters ?? Filters(),
    postsFetchStatus = postsFetchStatus ?? PostsFetchStatus(isFetching: false, nextStartIndex: 0,postsLoaded: [], postsNewlyArrived: []),
    uploadStatus = uploadStatus ?? UploadStatus(isPosting: false);
  
  AppState copyWith({
    String? currentRoute,
    LoginStatus? loginStatus,
    Filters? filters,
    PostsFetchStatus? postsFetchStatus,
    UploadStatus? uploadStatus
  }){
    return AppState(
      currentRoute: currentRoute ?? this.currentRoute,
      loginStatus: loginStatus ?? this.loginStatus, 
      filters: filters ?? this.filters,
      postsFetchStatus: postsFetchStatus ?? this.postsFetchStatus,
      uploadStatus: uploadStatus ?? this.uploadStatus);
  }
  @override
  int get hashCode =>
      currentRoute.hashCode ^
      loginStatus.hashCode ^
      filters.hashCode ^
      postsFetchStatus.hashCode ^
      uploadStatus.hashCode;

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
      other is AppState &&
          currentRoute == other.currentRoute &&
          runtimeType == other.runtimeType &&
          loginStatus == other.loginStatus &&
          postsFetchStatus == other.postsFetchStatus &&
          uploadStatus == other.uploadStatus;
}