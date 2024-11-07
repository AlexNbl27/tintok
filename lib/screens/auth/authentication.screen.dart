import 'package:flutter/material.dart';
import 'package:tintok/screens/auth/login.tab.dart';
import 'package:tintok/screens/auth/register.tab.dart';
import 'package:tintok/services/authentication.service.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});
  static AuthenticationService authService = AuthenticationService.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: DefaultTabController(
          animationDuration: const Duration(milliseconds: 200),
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bienvenue !',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Veuillez saisir vos informations',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              const TabBar(
                tabs: [Tab(text: "Se connecter"), Tab(text: "S'inscrire")],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: TabBarView(
                  children: [
                    LoginTab(authService: authService),
                    RegisterTab(authService: authService),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
