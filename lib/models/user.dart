class User {
  final String username;
  final String email;
  final String nickname;
  final String token;

  User({
    required this.username,
    required this.email,
    required this.nickname,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      token: json['token'] as String? ?? '',
    );
  }
}
