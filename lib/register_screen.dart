import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // package0 yox, package!
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      await ref.read(authControllerProvider).signUp(
            emailController.text.trim(),
            passwordController.text.trim(),
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Qeydiyyat xətası: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qeydiyyat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email daxil edin';
                  if (!value.contains('@')) return 'Düzgün email formatı daxil edin';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Şifrə (min. 6 simvol)', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Şifrə daxil edin';
                  if (value.length < 6) return 'Şifrə ən az 6 simvol olmalıdır';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: handleRegister,
                      child: const Text('Qeydiyyatı Tamamla'),
                    ),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Artıq hesabınız var? Daxil olun'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}