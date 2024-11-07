import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationService {
  AuthenticationService._();
  static final AuthenticationService _instance = AuthenticationService._();
  static AuthenticationService get instance => _instance;
  final GoTrueClient supauth = Supabase.instance.client.auth;

  User? get currentUser => supauth.currentUser;

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await supauth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> registerWithEmail(
      String email, String password, String username) async {
    try {
      await supauth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
        },
      );
    } on AuthApiException catch (e) {
      throw Exception(e.message);
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    try {
      await supauth.signOut();
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }
}
