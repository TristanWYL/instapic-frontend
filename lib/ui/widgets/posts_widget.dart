import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:instapic/misc/config.dart';
import 'package:instapic/models/apple_state.dart';
import 'package:instapic/models/fetch_posts_status.dart';
import 'package:instapic/models/post.dart';
import 'package:instapic/redux/actions/action_fetch_posts.dart';
import 'package:instapic/redux/selectors/selectors.dart';
import 'package:instapic/ui/keys.dart';
import 'package:redux/redux.dart';

class PagedImageListView extends StatefulWidget {
  PagedImageListView({Key? key}) : super(key: key);

  @override
  _PagedImageListViewState createState() => _PagedImageListViewState();
}

class _PagedImageListViewState extends State<PagedImageListView> {
  int start = 0;
  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      var triggerFetchMoreSize =
          0.99 * _scrollController.position.maxScrollExtent;
      if (_scrollController.position.pixels > triggerFetchMoreSize) {
        // call fetch more here
        // print("From scrollcontroller");
        _fetchPosts();
      }
    });
    // print("From init");
    _fetchPosts();
  }

  void _fetchPosts() {
    final _store = StoreProvider.of<AppState>(context, listen: false);
    if(!selectorIsFetchingPosts(selectorPostsStatus(_store.state))){
      _store.dispatch(ActionFetchPosts(
        start: selectorPostsStatus(_store.state).nextStartIndex,
        filters: selectorFilters(_store.state)));
    }
    // print("_fetchPosts(nextStartIndex:${selectorPostsStatus(_store.state).nextStartIndex});");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      // ignoreChange: (state){
      //   return true;
      // },
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return ListView.builder(
            controller: _scrollController,
            itemCount: vm.postsFetchStatus.postsLoaded.length + 1,
            itemBuilder: (context, index) {
              if (vm.postsFetchStatus.postsLoaded.length == index) {
                // print("ListView ItemBuilder");
                if (vm.postsFetchStatus.isFetching) {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(key: Key(WidgetKeys.circularProgressIndicatorForLoading), strokeWidth: 2.0)),
                  );
                } else if (vm.postsFetchStatus.postsNewlyArrived.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: 100.0,
                        height: 24.0,
                        child: Text("No more posts!")),
                  );
                } else {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: 100.0, height: 24.0, child: Text("No more posts!")),
                  );
                }
              }
              return PostHolder(post: vm.postsFetchStatus.postsLoaded[index]);
            }
          );
      },
    );
  }
}

class _ViewModel {
  final PostsFetchStatus postsFetchStatus;

  _ViewModel({
    required this.postsFetchStatus,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      // fetchPosts: () {
      //   print(
      //       "Fetching next:${selectorPostsStatus(store.state).nextStartIndex}");
      //   store.dispatch(ActionFetchPosts(
      //       start: selectorPostsStatus(store.state).nextStartIndex,
      //       filters: selectorFilters(store.state)));
      // },
      postsFetchStatus: selectorPostsStatus(store.state),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          postsFetchStatus == other.postsFetchStatus;

  @override
  int get hashCode => postsFetchStatus.hashCode;
}

class PostHolder extends StatelessWidget {
  const PostHolder({Key? key, required this.post}) : super(key: key);
  final Post post;

  static Widget getTextHolder(Icon icon, String text) {
    return Padding(
      padding: EdgeInsets.only(top: 0, left: 20, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          SizedBox(
            width: 20,
          ),
          Flexible(child: Text(text))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 522,
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            // margin: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      width: 500,
                      height: 300,
                      placeholder: (context, url) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text("$url\n$error"),
                              )
                            ],
                          ),
                        );
                      },
                      fit: BoxFit.contain,
                      imageUrl: Config.BASE_URL + post.pictureUrl,
                    ),
                  ),
                ),
                getTextHolder(
                    Icon(
                      Icons.person_outline_rounded,
                      color: Colors.amber,
                    ),
                    post.username),
                getTextHolder(
                    Icon(Icons.more_time_outlined, color: Colors.orange),
                    post.uploadedDatetime.toString()),
                getTextHolder(
                    Icon(Icons.description_outlined, color: Colors.green),
                    post.description),
              ],
            )),
      ),
    );
  }
}
