import 'package:flutter/material.dart';
import 'package:tintok/screens/auth/login.tab.dart';
import 'package:tintok/screens/auth/register.tab.dart';
import 'package:tintok/services/authentication.service.dart';
import 'package:tintok/tools/extensions/context.extension.dart';

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
              Text(
                context.translations.welcome,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.translations.pleaseTypeYourInformations,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              TabBar(
                tabs: [Tab(text: context.translations.login), Tab(text: context.translations.register)],
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
