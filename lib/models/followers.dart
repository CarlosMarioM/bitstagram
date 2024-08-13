class Follower {
  final String id;
  final String followerId;
  final String followeeId;
  final DateTime createdAt;

  Follower({
    required this.id,
    required this.followerId,
    required this.followeeId,
    required this.createdAt,
  });

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      id: json['id'],
      followerId: json['follower_id'],
      followeeId: json['followee_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'follower_id': followerId,
      'followee_id': followeeId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
