class Follower {
  final String id;
  final String followerId;
  final String followeeId;
  final DateTime createdAt;

  Follower({
    required this.id,
    required this.followeeId,
    required this.followerId,
    required this.createdAt,
  });

  factory Follower.fromMap(Map<String, dynamic> map) {
    return Follower(
      id: map['id'],
      followeeId: map['followee_id'],
      followerId: map['follower_id'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'followee_id': followeeId,
      'follower_id': followerId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
