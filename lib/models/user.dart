class User {
  String? id;
  String? nickname;
  final String email;
  final String password;
  DateTime? createdAt;

  User({
    this.id,
    this.nickname,
    required this.email,
    required this.password,
    this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nickname: map['nickname'],
      email: map['email'],
      password: map['password'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickname': nickname,
      'email': email,
      'password': password,
      'created_At': createdAt
    };
  }
}
