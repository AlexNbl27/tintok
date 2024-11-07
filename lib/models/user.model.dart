import 'package:tintok/services/database.service.dart';

class User {
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

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uuid: map['uuid'],
      email: map['email'],
      avatarUrl: map['avatar_url'],
      username: map['username'],
    );
  }

  static Future<User> getFromUuid(String uuid) async {
    final DatabaseService database = DatabaseService.instance;
    // database
    //     .getElements(
    //         table: 'users',
    //         conditionOnColumn: 'uuid',
    //         conditionValue: uuid,
    //         conditionType: ConditionType.equal)
    //     .then((value) {
    //   return User.fromMap(value[0]);
    // });
    return User(
      uuid: 'uuid',
      email: 'email',
      avatarUrl: 'avatarUrl',
      username: 'username',
    );
  }
}
