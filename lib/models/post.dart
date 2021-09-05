class Post extends Object {
  final String username;
  final String pictureUrl;
  final String description;
  final DateTime uploadedDatetime;

  Post(this.username, this.pictureUrl, this.description, this.uploadedDatetime);

  Post.fromJSON(Map<String, dynamic> json)
      : username = json['username'],
        pictureUrl = json['url'],
        description = json['description'],
        uploadedDatetime = DateTime.parse(json['timestamp']);

  @override
  int get hashCode =>
      username.hashCode ^
      pictureUrl.hashCode ^
      description.hashCode ^
      uploadedDatetime.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          pictureUrl == other.pictureUrl &&
          description == other.description &&
          uploadedDatetime == other.uploadedDatetime;
}
