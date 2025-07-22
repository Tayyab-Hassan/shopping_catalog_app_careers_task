import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../Models/cart_item_model.dart';

// to store the cart item localy using sheardPreferences
class CartStorageService {
  static const String _cartKey = 'cart_items';

  Future<void> saveCartItems(Map<int, CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encodedItems = items.values.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, encodedItems);
  }

  Future<Map<int, CartItem>> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? cartList = prefs.getStringList(_cartKey);
    if (cartList == null) return {};
    final Map<int, CartItem> cartItems = {};
    for (final itemStr in cartList) {
      final item = CartItem.fromJson(jsonDecode(itemStr));
      cartItems[item.product.id] = item;
    }
    return cartItems;
  }
}
