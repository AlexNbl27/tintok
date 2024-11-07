import 'package:tintok/constants/supabase.constant.dart';
import 'package:tintok/services/database.service.dart';

class User {
  String uuid;
  String? avatarUrl;
  String username;
  DateTime createdAt;

  User({
    required this.uuid,
    this.avatarUrl,
    required this.username,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uuid: map['uuid'],
      username: map['username'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  static Future<User> getFromUuid(String uuid) async {
    final DatabaseService database = DatabaseService.instance;
    return database
        .getElements(
            table: SupabaseConstant.usersTable,
            conditionOnColumn: 'uuid',
            conditionValue: uuid,
            conditionType: ConditionType.equal)
        .then((value) {
      return User.fromMap(value[0]);
    });
  }
}
