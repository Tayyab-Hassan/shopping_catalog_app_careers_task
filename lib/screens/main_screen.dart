import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shopping_catalog_app/Providers/cart_provider.dart';
import 'package:shopping_catalog_app/screens/cart_screen.dart';
import 'package:shopping_catalog_app/screens/favorites_screen.dart';
import 'package:shopping_catalog_app/screens/product_catalog_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of the main screens to be displayed
  static const List<Widget> _widgetOptions = <Widget>[
    ProductCatalogScreen(),
    FavoritesScreen(),
    CartScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Iconsax.shop),
            activeIcon: Icon(Iconsax.shop5),
            label: 'Store',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Iconsax.heart),
            activeIcon: Icon(Iconsax.heart5),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, cart, child) {
                return badges.Badge(
                  showBadge: cart.itemCount > 0,
                  badgeContent: Text(
                    cart.itemCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  position: badges.BadgePosition.topEnd(top: -12, end: -12),
                  child: const Icon(Iconsax.shopping_cart),
                );
              },
            ),
            activeIcon: Consumer<CartProvider>(
              builder: (context, cart, child) {
                return badges.Badge(
                  showBadge: cart.itemCount > 0,
                  badgeContent: Text(
                    cart.itemCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  position: badges.BadgePosition.topEnd(top: -12, end: -12),
                  child: const Icon(Iconsax.shopping_cart5),
                );
              },
            ),
            label: 'Cart',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}
