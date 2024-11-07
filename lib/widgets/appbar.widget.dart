import 'package:flutter/material.dart';
import 'package:tintok/models/user.model.dart';
import 'package:tintok/screens/user_profile.dart';
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
          // Titre de l'application à gauche
          const Text(
            'TinTok',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Row pour les deux icônes à droite
          Row(
            children: [
              // Icône de profil
              IconButton(
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserProfile(
                      user: User(
                        uuid: authService.currentUser!.id,
                        username: authService.currentUser!.userMetadata!['username'] ?? 'Mon profil',
                        createdAt: DateTime.parse(authService.currentUser!.createdAt),
                      ),
                    ),
                  ));
                },
              ),
              // Icône de déconnexion
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
        ],
      ),
    );
  }
}
