import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_catalog_app/Models/cart_item_model.dart';
import 'package:shopping_catalog_app/Providers/cart_provider.dart';

class CartListItem extends StatelessWidget {
  final CartItem cartItem;

  const CartListItem({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Dismissible(
      key: ValueKey(cartItem.product.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cartProvider.removeItem(cartItem.product.id);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(cartItem.product.image)),
            title: Text(cartItem.product.title),
            subtitle: Text('Total: \$${cartItem.totalPrice.toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    cartProvider.updateQuantity(cartItem.product.id, cartItem.quantity - 1);
                  },
                ),
                Text('${cartItem.quantity}'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    cartProvider.updateQuantity(cartItem.product.id, cartItem.quantity + 1);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
