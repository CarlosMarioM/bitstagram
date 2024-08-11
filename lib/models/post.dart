class Post {
  final String id;
  final String userId;
  final String content;
  final String mediaUrl; // URL for the image or video
  final String mediaType; // 'image' or 'video'
  final DateTime createdAt;
  int likesCount;
  bool likedByMe;

  Post({
    required this.id,
    required this.userId,
    required this.content,
    required this.mediaUrl,
    required this.mediaType, // media type
    required this.createdAt,
    this.likesCount = 0,
    this.likedByMe = false,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      userId: map['user_id'],
      content: map['content'],
      mediaUrl: map['media_url'], // media URL mapping
      mediaType: map['media_type'], // media type mapping
      createdAt: DateTime.parse(map['created_at']),
      likesCount: map['likes_count'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'media_url': mediaUrl, // map media URL
      'media_type': mediaType, // map media type
      'created_at': createdAt.toIso8601String(),
      'likes_count': likesCount,
    };
  }
}
