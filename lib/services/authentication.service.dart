import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:tintok/models/user.model.dart';

class AuthenticationService {
  Future<User?> signInWithEmail(String email, String password) async {
    final sb.SupabaseClient supabase = sb.Supabase.instance.client;
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
    return null;
  }

  Future<User?> registerWithEmail(
      String email, String password, String username) async {
    final sb.SupabaseClient supabase = sb.Supabase.instance.client;
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
    return null;
  }

  Future<User?> updateUser(User user) async {
    final sb.SupabaseClient supabase = sb.Supabase.instance.client;
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
    return null;
  }

  Future signOut() async {
    final sb.SupabaseClient supabase = sb.Supabase.instance.client;
    await supabase.auth.signOut();
  }
}
