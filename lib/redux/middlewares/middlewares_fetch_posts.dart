import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/filters.dart';
import 'package:instapic/models/post.dart';
import 'package:instapic/redux/actions/action_fetch_posts.dart';
import 'package:instapic/redux/actions/action_others.dart';
import 'package:instapic/remote/api.dart';
import 'package:instapic/remote/response.dart';
import 'package:redux/redux.dart';

class MiddlewaresFetchPosts{
  final Api api;
  MiddlewaresFetchPosts(this.api);

  List<Middleware<AppState>> getMiddlewares(){
      return [_fetchPosts];
  }
  // A middleware takes in 3 parameters: your Store, which you can use to
  // read state or dispatch new actions, the action that was dispatched, 
  // and a `next` function. The first two you know about, and the `next` 
  // function is responsible for sending the action to your Reducer, or 
  // the next Middleware if you provide more than one.
  //
  // Middleware do not return any values themselves. They simply forward
  // actions on to the Reducer or swallow actions in some special cases.
  void _fetchPosts(Store<AppState> store, action, NextDispatcher next){
    if(action is ActionFetchPosts){
      api.posts(
        start: action.start, 
        limit: action.limit,
        username: action.filters.username,
        sortby: action.filters.sortby == QuerySortBy.NONE ? null:action.filters.sortby.value,
        order: action.filters.order?.value
        ).then((apiResponse){
          if(apiResponse.code == ApiResponse.CODE_OK){
            // print("fetch posts successfully.");
            List<Post> _posts = [];
            (apiResponse.data as List).forEach((element){
              _posts.add(Post.fromJSON(element));
            });
            store.dispatch(ActionFetchPostsSucceeded(_posts));
          }else{
            // print("fetch posts unsuccessfully.");
            store.dispatch(ActionFetchPostsFailed());
            store.dispatch(ActionPromptError(apiResponse.msg));
          }
        });
    }
    // Make sure our actions continue on to the reducer.
    next(action);
  }
}