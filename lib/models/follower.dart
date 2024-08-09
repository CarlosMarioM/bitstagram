class Follower {
  final String id;
  final String userId;
  final String followerId;
  final DateTime createdAt;

  Follower({
    required this.id,
    required this.userId,
    required this.followerId,
    required this.createdAt,
  });

  factory Follower.fromMap(Map<String, dynamic> map) {
    return Follower(
      id: map['id'],
      userId: map['user_id'],
      followerId: map['follower_id'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'follower_id': followerId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
