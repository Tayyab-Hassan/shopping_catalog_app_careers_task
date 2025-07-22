import 'package:shopping_catalog_app/Models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() => {'product': product.toJson(), 'quantity': quantity};

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      CartItem(product: Product.fromJson(json['product']), quantity: json['quantity']);
}
