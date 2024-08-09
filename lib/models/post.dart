class Post {
  final String id;
  final String userId;
  final String content;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      userId: map['user_id'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
