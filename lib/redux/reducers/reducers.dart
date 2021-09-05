import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/reducers/reducers_fetch_posts.dart';
import 'package:instapic/redux/reducers/reducers_filters.dart';
import 'package:instapic/redux/reducers/reducers_navigation.dart';
import 'package:instapic/redux/reducers/reducers_sign_in_out_up.dart';
import 'package:instapic/redux/reducers/reducers_upload_post.dart';

// Create the State reducer by combining many smaller reducers into one!
AppState appReducer(AppState state, action) {
  return AppState(
    currentRoute: reducersNavigation(state.currentRoute, action),
    filters: reducersFilters(state.filters, action),
    loginStatus: reducersSign(state.loginStatus, action),
    uploadStatus: reducersPostingStatus(state.uploadStatus, action),
    postsFetchStatus: reducersFetchStatus(state.postsFetchStatus, action)
  );
}