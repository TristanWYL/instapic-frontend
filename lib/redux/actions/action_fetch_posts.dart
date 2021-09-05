import 'package:instapic/misc/config.dart';
import 'package:instapic/models/filters.dart';
import 'package:instapic/models/post.dart';

class ActionFetchPosts{
  final int start;
  final int limit;
  final Filters filters;

  ActionFetchPosts({this.start=0, this.limit=Config.PAGE_SIZE, required this.filters});
}

class ActionFetchPostsSucceeded{
  final List<Post> posts;
  ActionFetchPostsSucceeded(this.posts);
}

class ActionFetchPostsFailed{}

// class ActionFetchPostsFailed{
//   final String error;
//   ActionFetchPostsFailed(this.error);
// }