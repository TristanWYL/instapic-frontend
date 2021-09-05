class UploadStatus {
  final bool isPosting;
  final bool? isSucceeded;

  UploadStatus(
      {required this.isPosting,
      this.isSucceeded,});

  @override
  int get hashCode =>
      isPosting.hashCode ^ isSucceeded.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UploadStatus &&
          runtimeType == other.runtimeType &&
          isPosting == other.isPosting &&
          isSucceeded == other.isSucceeded;
}
