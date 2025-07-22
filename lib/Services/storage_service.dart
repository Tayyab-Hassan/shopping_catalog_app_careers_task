import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _favoritesKey = 'favorite_product_ids';

  // Loads the set of favorite product IDs from local storage.
  Future<Set<int>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList(_favoritesKey) ?? [];
    return favoriteIds.map((id) => int.parse(id)).toSet();
  }

  // Saves the given set of favorite product IDs to local storage.
  Future<void> saveFavorites(Set<int> favoriteProductIds) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = favoriteProductIds.map((id) => id.toString()).toList();
    await prefs.setStringList(_favoritesKey, favoriteIds);
  }
}
