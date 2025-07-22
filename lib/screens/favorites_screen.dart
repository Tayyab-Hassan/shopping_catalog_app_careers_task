import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_catalog_app/Models/product_model.dart';
import 'package:shopping_catalog_app/Providers/product_provider.dart';
import 'package:shopping_catalog_app/Widgets/product_grid.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          final List<Product> favoriteProducts = provider.favoriteProducts;

          if (favoriteProducts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text('No favorites yet!', style: TextStyle(fontSize: 22, color: Colors.grey)),
                  Text(
                    'Tap the heart on any product to save it here.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Reuse the ProductGrid widget to display the favorite items
          return ProductGrid(products: favoriteProducts, heroTagPrefix: '2');
        },
      ),
    );
  }
}
