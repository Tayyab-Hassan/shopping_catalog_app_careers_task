import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_catalog_app/Providers/cart_provider.dart';
import 'package:shopping_catalog_app/Providers/product_provider.dart';
import 'package:shopping_catalog_app/Services/api_services.dart';
import 'package:shopping_catalog_app/Services/storage_service.dart';
import 'package:shopping_catalog_app/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        Provider<StorageService>(create: (_) => StorageService()),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(context.read<ApiService>(), context.read<StorageService>()),
        ),
        // Add the CartProvider here
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Modern Shopping Catalog',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.grey[50],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Poppins',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 1,
            shadowColor: Colors.black26,
            iconTheme: IconThemeData(color: Colors.black87),
            titleTextStyle: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const MainScreen(),
      ),
    );
  }
}
