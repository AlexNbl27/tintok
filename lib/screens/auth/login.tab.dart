import 'package:flutter/material.dart';
import 'package:tintok/services/authentication.service.dart';

class LoginTab extends StatelessWidget {
  const LoginTab({super.key, required this.authService});
  final AuthenticationService authService;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: emailController,
                hintText: 'Email',
                icon: Icons.email,
                validator: (value) => value == null || value.isEmpty
                    ? 'Veuillez entrer votre email'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: passwordController,
                hintText: 'Mot de passe',
                icon: Icons.lock,
                obscureText: true,
                validator: (value) => value == null || value.isEmpty
                    ? 'Veuillez entrer votre mot de passe'
                    : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _login(
                      context, formKey, emailController, passwordController),
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => DefaultTabController.of(context).animateTo(1),
          child: const Text(
            'Pas de compte ? Inscrivez-vous',
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }

  Future<void> _login(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    if (formKey.currentState!.validate()) {
      try {
        await authService.signInWithEmail(
            emailController.text, passwordController.text);
      } on Exception catch (e) {
        debugPrint(e.toString());
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible de se connecter'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
