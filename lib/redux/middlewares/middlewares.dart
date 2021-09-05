import 'package:instapic/models/apple_state.dart';
import 'package:instapic/redux/middlewares/middlewares_fetch_posts.dart';
import 'package:instapic/redux/middlewares/middlewares_navigation.dart';
import 'package:instapic/redux/middlewares/middlewares_other.dart';
import 'package:instapic/redux/middlewares/middlewares_sign_in_out_up.dart';
import 'package:instapic/redux/middlewares/middlewares_upload_posts.dart';
import 'package:instapic/remote/api.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> getMiddlewares(Api api){
  return 
    MiddlewaresOther().getMiddlewares() +
    MiddlewaresFetchPosts(api).getMiddlewares() +
    MiddlewaresSign(api).getMiddlewares() +
    MiddlewaresUploadPost(api).getMiddlewares() + 
    MiddlewaresNavigation().getMiddlewares();
}