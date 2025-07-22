import 'package:flutter/material.dart';
import 'package:shopping_catalog_app/Services/cart_local_storage_services.dart';

import '../Models/cart_item_model.dart';
import '../Models/product_model.dart';

class CartProvider with ChangeNotifier {
  final CartStorageService _cartStorage = CartStorageService();

  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalPrice {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  CartProvider() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final loadedItems = await _cartStorage.loadCartItems();
    _items.addAll(loadedItems);
    notifyListeners();
  }

  void _persistCart() {
    _cartStorage.saveCartItems(_items);
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existing) => CartItem(product: existing.product, quantity: existing.quantity + 1),
      );
    } else {
      _items[product.id] = CartItem(product: product);
    }
    _persistCart();
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.remove(productId);
    _persistCart();
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    if (_items.containsKey(productId)) {
      if (quantity > 0) {
        _items[productId] = CartItem(product: _items[productId]!.product, quantity: quantity);
      } else {
        _items.remove(productId);
      }
      _persistCart();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _persistCart();
    notifyListeners();
  }
}
