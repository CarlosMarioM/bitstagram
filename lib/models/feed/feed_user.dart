import 'package:equatable/equatable.dart';

class FeedUser extends Equatable {
  final int id;
  final String name;
  final String url;

  const FeedUser(this.id, this.name, this.url);

  FeedUser.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"] ?? "",
        url = json["url"] ?? "";

  @override
  List<Object> get props => [id, name, url];

  static const empty = FeedUser(0, "", "");
}
