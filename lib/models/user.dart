class User {
  String? id;
  String? nickname;
  String? phone;
  String? photoUrl;
  final String email;
  final String password;
  DateTime? createdAt;

  User(
      {this.id,
      this.nickname,
      required this.email,
      required this.password,
      this.createdAt,
      this.phone,
      this.photoUrl});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nickname: map['nickname'],
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
      photoUrl: map['photo_url'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickname': nickname,
      'email': email,
      'password': password,
      'photo_url': photoUrl,
      'phont': phone,
      'created_At': createdAt
    };
  }

  static final empty = User(email: "", password: "");
}
