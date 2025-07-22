import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_catalog_app/Models/product_model.dart';
import 'package:shopping_catalog_app/Providers/cart_provider.dart';
import 'package:shopping_catalog_app/Providers/product_provider.dart';
import 'package:shopping_catalog_app/screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  // Add a prefix to make the Hero tag unique per screen
  final String heroTagPrefix;

  const ProductCard({super.key, required this.product, required this.heroTagPrefix});

  @override
  Widget build(BuildContext context) {
    // Create the full, unique hero tag
    final String uniqueHeroTag = '${heroTagPrefix}product-image-${product.id}';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: product,
              // Pass the unique tag to the detail screen
              heroTag: uniqueHeroTag,
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shadowColor: Colors.deepPurple.withAlpha((0.2 * 255).toInt()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Hero(
                        // Use the unique hero tag here
                        tag: uniqueHeroTag,
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, progress) => progress == null
                              ? child
                              : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported_outlined, size: 40, color: Colors.grey),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Consumer<ProductProvider>(
                        builder: (context, provider, child) {
                          final isFavorite = provider.favoriteProductIds.contains(product.id);
                          return GestureDetector(
                            onTap: () {
                              provider.toggleFavorite(product.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    !isFavorite
                                        ? '${product.title} added to favorites!'
                                        : '${product.title} removed from favorites!',
                                    style: TextStyle(color: !isFavorite ? Colors.deepPurple : Colors.red),
                                  ),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.white.withAlpha((0.8 * 255).toInt()),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.black.withAlpha((0.05 * 255).toInt()),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(scale: animation, child: child),
                                child: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  key: ValueKey<bool>(isFavorite),
                                  color: isFavorite ? Colors.redAccent : Colors.black54,
                                  size: 22,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_shopping_cart, color: Colors.grey[800], size: 22),
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false).addItem(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product.title} added to cart!',
                                  style: const TextStyle(color: Colors.deepPurple),
                                ),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.white.withAlpha((0.8 * 255).toInt()),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
