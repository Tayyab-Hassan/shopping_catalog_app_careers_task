// This widget is responsible for displaying the products in a grid layout.
// It's made responsive by adjusting the column count based on screen width.
// Animations are added for a more engaging user experience.

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shopping_catalog_app/Models/product_model.dart';
import 'package:shopping_catalog_app/Widgets/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  // Add the prefix to the constructor
  final String heroTagPrefix;

  const ProductGrid({super.key, required this.products, required this.heroTagPrefix});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 ? 5 : (screenWidth > 800 ? 4 : (screenWidth > 500 ? 3 : 2));

    return AnimationLimiter(
      child: GridView.builder(
        key: ValueKey(products.length),
        padding: const EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 400),
            columnCount: crossAxisCount,
            child: ScaleAnimation(
              child: FadeInAnimation(
                // Pass the prefix down to the ProductCard
                child: ProductCard(product: products[index], heroTagPrefix: heroTagPrefix),
              ),
            ),
          );
        },
      ),
    );
  }
}
