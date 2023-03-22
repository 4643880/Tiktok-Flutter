class Video {
  final String uid;
  final String username;
  final String profilePhoto;
  final String videoid;
  final List likes;
  final int commentCount;
  final int shareCount;
  final String songName;
  final String caption;
  final String videoUrl;
  final String thumbnailUrl;

  Video({
    required this.uid,
    required this.username,
    required this.profilePhoto,
    required this.videoid,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.songName,
    required this.caption,
    required this.videoUrl,
    required this.thumbnailUrl,
  });

  factory Video.fromSnap({required Map<String, dynamic> snapshot}) {
    return Video(
      uid: snapshot["uid"],
      username: snapshot["username"],
      profilePhoto: snapshot["profilePhoto"],
      videoid: snapshot["videoid"],
      likes: snapshot["likes"],
      commentCount: snapshot["commentCount"],
      shareCount: snapshot["shareCount"],
      songName: snapshot["songName"],
      caption: snapshot["caption"],
      videoUrl: snapshot["videoUrl"],
      thumbnailUrl: snapshot["thumbnailUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "profilePhoto": profilePhoto,
        "videoid": videoid,
        "likes": likes,
        "commentCount": commentCount,
        "shareCount": shareCount,
        "songName": songName,
        "caption": caption,
        "videoUrl": videoUrl,
        "thumbnailUrl": thumbnailUrl,
      };
}
