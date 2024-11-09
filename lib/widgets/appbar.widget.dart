import 'package:flutter/material.dart';
import 'package:tintok/models/user.model.dart';
import 'package:tintok/screens/user_profile.dart';
import 'package:tintok/services/authentication.service.dart';
import 'package:tintok/tools/extensions/context.extension.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});
  static AuthenticationService authService = AuthenticationService.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.surface),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TinTok',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                    ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserProfile(
                            user: User(
                              uuid: authService.currentUser!.id,
                              username: authService
                                      .currentUser!.userMetadata!['username'] ??
                                  context.translations.myProfile,
                              createdAt: DateTime.parse(
                                  authService.currentUser!.createdAt),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => authService.signOut(),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
