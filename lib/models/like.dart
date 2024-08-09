class Like {
  final String id;
  final String userId;
  final String postId;

  Like({
    required this.id,
    required this.userId,
    required this.postId,
  });

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      id: map['id'],
      userId: map['user_id'],
      postId: map['post_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
    };
  }
}
