// These selectors work as a single point of access to the AppState
// If memoizing feature is needed, or selector combination is needed, 
// turn to reselect plugin at 
// https://pub.dev/packages/reselect

import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/fetch_posts_status.dart';
import 'package:instapic/models/filters.dart';
import 'package:instapic/models/login_status.dart';

LoginStatus selectorLoginStatus(AppState state) => state.loginStatus;
Filters selectorFilters(AppState state) => state.filters;
PostsFetchStatus selectorPostsStatus(AppState state) => state.postsFetchStatus;
bool selectorIsPosting(AppState state) => state.uploadStatus.isPosting;
bool? selectorUploadSucceeded(AppState state) => state.uploadStatus.isSucceeded;
String selectorCurrentRoute(AppState state) => state.currentRoute;

bool selectorIsLogin(LoginStatus status) => status.isLogin;
bool selectorIsFetchingPosts(PostsFetchStatus status) => status.isFetching;
String selectorUsername(LoginStatus status) => status.username ?? "";

