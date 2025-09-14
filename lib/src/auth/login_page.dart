import 'package:flutter/material.dart';
import '../common/api_client.dart';
import 'register_page.dart';
import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  Future<void> login() async {
    setState(() => loading = true);
    try {
      final response = await ApiClient.dio.post('/login', data: {
        'email': emailCtrl.text.trim(),
        'password': passCtrl.text,
      });

      final token = response.data['token'];
      await ApiClient.setToken(token);

      Navigator.pushReplacementNamed(context, '/products');
    } on DioException catch (e) {
      String msg = 'Login failed';
      if (e.response?.statusCode == 422) {
        msg = e.response!.data.toString();
      } else if (e.response?.statusCode == 401) {
        msg = 'Unauthorized: check credentials';
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
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(
            controller: emailCtrl,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: passCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: loading ? null : login,
            child: Text(loading ? 'Loading...' : 'Login'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/register'),
            child: const Text('Create account'),
          ),
        ]),
      ),
    );
  }
}
