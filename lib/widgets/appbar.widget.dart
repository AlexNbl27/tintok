import 'package:flutter/material.dart';
import 'package:tintok/services/authentication.service.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});
  static AuthenticationService authService = AuthenticationService.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54, // Couleur d'arrière-plan avec transparence
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TinTok', // Titre de l'application
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              authService.signOut();              
            },
          ),
        ],
      ),
    );
  }
}
