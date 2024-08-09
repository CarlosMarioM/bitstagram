class User {
  final String id;
  final String nickname;
  final String email;
  final String password;

  User({
    required this.id,
    required this.nickname,
    required this.email,
    required this.password,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nickname: map['nickname'],
      email: map['email'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickname': nickname,
      'email': email,
      'password': password,
    };
  }
}
