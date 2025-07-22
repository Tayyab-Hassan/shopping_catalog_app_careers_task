import 'package:flutter/material.dart';
import 'package:shopping_catalog_app/Models/product_model.dart';
import 'package:shopping_catalog_app/Services/api_services.dart';
import 'package:shopping_catalog_app/Services/storage_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'all';
  Set<int> _favoriteProductIds = {};
  String _searchQuery = '';

  ProductProvider(this._apiService, this._storageService);

  List<Product> get products => _filteredProducts;
  List<Product> get favoriteProducts => _products.where((p) => _favoriteProductIds.contains(p.id)).toList();
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  Set<int> get favoriteProductIds => _favoriteProductIds;

  Future<void> fetchAllData() async {
    // This method now throws errors to be caught by the UI layer.
    final favoritesFuture = _storageService.loadFavorites();
    final productsFuture = _apiService.getProducts();
    final categoriesFuture = _apiService.getCategories();

    _favoriteProductIds = await favoritesFuture;
    final fetchedProducts = await productsFuture;
    final fetchedCategories = await categoriesFuture;

    _products = fetchedProducts.map((p) {
      p.isFavorite = _favoriteProductIds.contains(p.id);
      return p;
    }).toList();

    _filteredProducts = List.from(_products);
    _categories = ['all', ...fetchedCategories];
    notifyListeners();
  }

  void _applyFilters() {
    List<Product> tempProducts = List.from(_products);

    // Apply category filter
    if (_selectedCategory.toLowerCase() != 'all') {
      tempProducts = tempProducts
          .where((product) => product.category.toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      tempProducts = tempProducts
          .where((product) => product.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    _filteredProducts = tempProducts;
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  Future<void> toggleFavorite(int productId) async {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }

    final productIndex = _products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      _products[productIndex].isFavorite = !_products[productIndex].isFavorite;
    }

    notifyListeners();
    await _storageService.saveFavorites(_favoriteProductIds);
  }
}
