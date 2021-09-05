import 'package:instapic/models/post.dart';

class PostsFetchStatus {
  final bool isFetching;
  final int nextStartIndex;
  final List<Post> postsLoaded;
  final List<Post> postsNewlyArrived;

  PostsFetchStatus(
      {required this.isFetching,
      required this.nextStartIndex,
      required this.postsLoaded,
      required this.postsNewlyArrived});

  PostsFetchStatus copyWith(
      {bool? isFetching,
      int? nextStartIndex,
      List<Post>? postsLoaded,
      List<Post>? postsNewlyArrived}) {
    return PostsFetchStatus(
      isFetching: isFetching ?? this.isFetching,
      nextStartIndex: nextStartIndex ?? this.nextStartIndex,
      postsLoaded: postsLoaded ?? this.postsLoaded,
      postsNewlyArrived: postsNewlyArrived ?? this.postsNewlyArrived,
    );
  }

  void merge() {
    postsLoaded.addAll(postsNewlyArrived);
    postsNewlyArrived.clear();
  }

  @override
  int get hashCode =>
      isFetching.hashCode ^ nextStartIndex.hashCode ^ postsLoaded.hashCode ^ postsNewlyArrived.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostsFetchStatus &&
          runtimeType == other.runtimeType &&
          isFetching == other.isFetching &&
          nextStartIndex == other.nextStartIndex &&
          postsLoaded == other.postsLoaded &&
          postsNewlyArrived == other.postsNewlyArrived;
}
