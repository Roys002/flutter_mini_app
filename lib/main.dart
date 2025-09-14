import 'package:flutter/material.dart';
import 'src/common/api_client.dart';
import 'src/auth/login_page.dart';
import 'src/auth/register_page.dart';
import 'src/products/product_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final initialRoute = ApiClient.token != null ? '/products' : '/';
    return MaterialApp(
      title: 'Mini E-Commerce',
      initialRoute: initialRoute,
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/products': (context) => ProductListPage(),
      },
    );
  }
}
