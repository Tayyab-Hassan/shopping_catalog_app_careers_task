import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_catalog_app/Providers/product_provider.dart';
import 'package:shopping_catalog_app/Widgets/category_selector.dart';
import 'package:shopping_catalog_app/Widgets/error_view.dart';
import 'package:shopping_catalog_app/Widgets/product_grid.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  ProductCatalogScreenState createState() => ProductCatalogScreenState();
}

class ProductCatalogScreenState extends State<ProductCatalogScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  Future<void>? _productsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch data when the screen is first loaded
    _productsFuture = context.read<ProductProvider>().fetchAllData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        context.read<ProductProvider>().search('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Search products...', border: InputBorder.none),
                onChanged: (query) {
                  context.read<ProductProvider>().search(query);
                },
              )
            : const Text('Shopping Catalog app'),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(_isSearching ? Icons.close : Icons.search), onPressed: _toggleSearch),
          // The cart icon is removed from here as it's now in the BottomNavBar
        ],
      ),
      body: Column(
        children: [
          Consumer<ProductProvider>(
            builder: (context, provider, child) {
              return CategorySelector(
                categories: provider.categories,
                selectedCategory: provider.selectedCategory,
                onCategorySelected: (category) {
                  provider.filterByCategory(category);
                },
              );
            },
          ),
          Expanded(
            child: FutureBuilder<void>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return ErrorView(
                    message: snapshot.error.toString(),
                    onRetry: () {
                      setState(() {
                        _productsFuture = context.read<ProductProvider>().fetchAllData();
                      });
                    },
                  );
                }
                return Consumer<ProductProvider>(
                  builder: (context, provider, child) {
                    if (provider.products.isEmpty) {
                      return Center(
                        child: Text(_isSearching ? 'No products match your search.' : 'No products found.'),
                      );
                    }
                    return ProductGrid(
                      key: ValueKey(provider.selectedCategory),
                      products: provider.products,
                      heroTagPrefix: 'catalog',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
