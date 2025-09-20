import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/post_provider.dart';
import 'login_screen.dart';
import 'post_screen.dart';
import 'product_screen.dart'; // pastikan sudah buat file ini

class HomeScreen extends StatelessWidget {
  final String role;
  const HomeScreen({required this.role, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home ($role)"),
          actions: [
            IconButton(
              onPressed: () async {
                await context.read<AuthProvider>().logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text("Lihat Posts"),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => PostScreen(role: role),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16), // jarak antar tombol
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProductScreen()),
                  );
                },
                child: const Text("Lihat Produk"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
