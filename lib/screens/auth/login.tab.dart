import 'package:flutter/material.dart';
import 'package:tintok/services/authentication.service.dart';
import 'package:tintok/tools/extensions/context.extension.dart';

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
                context: context,
                controller: emailController,
                hintText: context.translations.email,
                icon: Icons.email,
                validator: (value) => value == null || value.isEmpty
                    ? context.translations.pleaseTypeYourEmail
                    : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                context: context,
                controller: passwordController,
                hintText: context.translations.password,
                icon: Icons.lock,
                obscureText: true,
                validator: (value) => value == null || value.isEmpty
                    ? context.translations.pleaseTypeYourPassword
                    : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _login(
                      context, formKey, emailController, passwordController),
                  child: Text(
                    context.translations.login,
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => DefaultTabController.of(context).animateTo(1),
          child: Text(
            context.translations.dontHaveAnAccount,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required BuildContext context,
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
            SnackBar(
              content: Text(context.translations.unableToLogin),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}