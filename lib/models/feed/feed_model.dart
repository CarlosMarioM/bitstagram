import 'package:bitstagram/models/feed/feed_user.dart';
import 'package:bitstagram/models/user.dart';
import 'package:bitstagram/models/feed/video_model.dart';
import 'package:equatable/equatable.dart';

class FeedModel extends Equatable {
  final int id;
  final int width;
  final int height;
  final String image;
  final int duration;
  final FeedUser user;
  final List<VideoModel> videos;

  const FeedModel(this.id, this.width, this.height, this.image, this.duration,
      this.user, this.videos);

  FeedModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        width = json["width"] ?? 0,
        height = json["height"] ?? 0,
        image = json["image"] ?? "",
        duration = json["duration"] ?? 0,
        user = json["user"] != null
            ? FeedUser.fromJson(json["user"])
            : FeedUser.empty,
        videos = json["video_files"] != null
            ? (json["video_files"] as List)
                .map((i) => VideoModel.fromJson(i))
                .toList()
            : [];

  @override
  List<Object> get props => [id, width, height, image, duration, user];

  static const empty = FeedModel(0, 0, 0, "", 0, FeedUser.empty, []);
}
