// lib/src/auth/register_page.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../common/api_client.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    try {
      final response = await ApiClient.dio.post('/register', data: {
        'email': emailCtrl.text.trim(),
        'password': passCtrl.text,
      });

      final token = response.data['token'];
      await ApiClient.setToken(token);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful!")),
      );

      Navigator.pushReplacementNamed(context, '/products');
    } on DioException catch (e) {
      String msg = 'Registration failed';
      if (e.response?.statusCode == 422) {
        msg = e.response!.data.toString();
      } else if (e.response?.statusCode == 401) {
        msg = 'Unauthorized';
      } else {
        msg = e.message ?? "Unknown error";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!value.contains('@')) {
                  return 'Invalid email format';
                }
                return null;
              },
            ),
            TextFormField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : register,
              child: Text(loading ? 'Loading...' : 'Register'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Already have an account? Login'),
            ),
          ]),
        ),
      ),
    );
  }
}
