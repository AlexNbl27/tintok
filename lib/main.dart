import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tintok/firebase_options.dart';
import 'package:tintok/providers/authentication.provider.dart';
import 'package:tintok/screens/home.screen.dart';
import 'package:tintok/screens/login.screen.dart';
import 'package:tintok/services/authentication.service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthenticationProvider(AuthenticationService()),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer<AuthenticationProvider>(
        builder: (BuildContext context, AuthenticationProvider value,
            Widget? child) {
          return Scaffold(
            body: SafeArea(
              top: false,
              child: value.currentUser == null
                  ? const LoginScreen()
                  : const HomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
