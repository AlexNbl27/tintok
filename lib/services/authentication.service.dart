import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:tintok/models/user.model.dart';

class AuthenticationService {
  AuthenticationService._();
  static final AuthenticationService _instance = AuthenticationService._();
  static AuthenticationService get instance => _instance;
  final sb.SupabaseClient supabase = sb.Supabase.instance.client;

  User? get currentUser {
    if (supabase.auth.currentUser != null) {
      return User(
        uuid: supabase.auth.currentUser!.id,
        email: supabase.auth.currentUser!.email!,
        username: supabase.auth.currentUser!.userMetadata?['displayName'] ??
            supabase.auth.currentUser!.email!.split('@')[0],
        avatarUrl: supabase.auth.currentUser!.userMetadata?['avatar'],
      );
    }
    return null;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final sb.AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (res.user != null) {
        return User(
          uuid: res.user!.id,
          email: res.user!.email!,
          username: res.user!.userMetadata?['displayName'] ??
              res.user!.email!.split('@')[0],
          avatarUrl: res.user!.userMetadata?['avatar'],
        );
      }
    } on sb.AuthException catch (e) {
      throw Exception(e.message);
    }
    return null;
  }

  Future<User?> registerWithEmail(
      String email, String password, String username) async {
    try {
      final sb.AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (res.user != null) {
        return User(
          uuid: res.user!.id,
          email: res.user!.email!,
          username: res.user!.userMetadata?['displayName'] ??
              res.user!.email!.split('@')[0],
        );
      }
    } on sb.AuthException catch (e) {
      throw Exception(e.message);
    }
    return null;
  }

  Future<User?> updateUser(User user) async {
    try {
      if (supabase.auth.currentUser != null) {
        final sb.UserResponse res = await supabase.auth.updateUser(
          sb.UserAttributes(
            email: user.email,
            data: {
              'displayName': user.username,
            },
          ),
        );
        return User(
          uuid: res.user!.id,
          email: res.user!.email!,
          username: res.user!.userMetadata?['displayName'] ??
              res.user!.email!.split('@')[0],
          avatarUrl: res.user!.userMetadata?['avatar'],
        );
      }
    } on sb.AuthException catch (e) {
      throw Exception(e.message);
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } on sb.AuthException catch (e) {
      throw Exception(e.message);
    }
  }
}
