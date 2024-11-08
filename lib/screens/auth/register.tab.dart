import 'package:flutter/material.dart';
import 'package:tintok/services/authentication.service.dart';
import 'package:tintok/tools/extensions/context.extension.dart';

class RegisterTab extends StatelessWidget {
  const RegisterTab({super.key, required this.authService});
  final AuthenticationService authService;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final usernameController = TextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              _buildTextFormField(
                context: context,
                controller: usernameController,
                hintText: context.translations.username,
                icon: Icons.person,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.translations.pleaseTypeYourUsername;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                context: context,
                controller: emailController,
                hintText: context.translations.email,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.translations.pleaseTypeYourEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                context: context,
                controller: passwordController,
                hintText: context.translations.password,
                icon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.translations.pleaseTypeYourPassword;
                  }
                  return null;
                },
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
                  onPressed: () => _register(
                    context,
                    formKey,
                    emailController,
                    passwordController,
                    usernameController,
                  ),
                  child: Text(
                    context.translations.register,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => DefaultTabController.of(context).animateTo(0),
          child: Text(
            context.translations.alreadyHaveAnAccount,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }

  Future<void> _register(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController usernameController,
  ) async {
    if (formKey.currentState!.validate()) {
      try {
        await authService.registerWithEmail(
          emailController.text,
          passwordController.text,
          usernameController.text,
        );
      } catch (e) {
        if (context.mounted) {
          debugPrint(e.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.translations.unableToRegister),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}