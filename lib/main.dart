import 'package:flutter/material.dart';
import 'providers/product_provider.dart';
import 'package:flutter_app_first/theme.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'api/api_client.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  ApiClient.setupInterceptor(); // setup interceptor token expired

    runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()), // ✅ ditambahkan
        // nanti kalau ada CartProvider, PostProvider global, tambahin juga disini
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loading = true;
  String? _role;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _initSession();
  }

  Future<void> _initSession() async {
    final auth = context.read<AuthProvider>();
    await auth.loadSession();
    setState(() {
      _loading = false;
      _isLoggedIn = auth.isLoggedIn;
      _role = auth.role;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: "Flutter + Laravel",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _isLoggedIn ? HomeScreen(role: _role ?? "user") : LoginScreen(),
    );
  }
}
