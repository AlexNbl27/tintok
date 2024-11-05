class User{
  String uuid;
  String email;
  String? avatarUrl;
  String username;

  User({
    required this.uuid,
    required this.email,
    this.avatarUrl,
    required this.username,
  });
}