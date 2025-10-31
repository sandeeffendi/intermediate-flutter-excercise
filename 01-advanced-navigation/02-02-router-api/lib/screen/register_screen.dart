import 'package:declarative_navigation/model/user.dart';
import 'package:declarative_navigation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;

  const RegisterScreen({
    Key? key,
    required this.onLogin,
    required this.onRegister,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Screen")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),

          // register form
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "Email"),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // register button
                context.watch<AuthProvider>().isLoadingRegister
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final User user = User(
                            email: emailController.text,
                            password: passwordController.text,
                          );

                          final readAuth = context.read<AuthProvider>();

                          final result = await readAuth.saveUser(user);
                          
                          if (result) widget.onRegister();
                        }
                      },
                      child: const Text("REGISTER"),
                    ),

                const SizedBox(height: 8),

                // register button
                OutlinedButton(
                  onPressed: () => widget.onLogin(),
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
