import 'package:flutter_market_alpha/models/product.dart';

class ShopProduct {
  final Product product;
  int quantity;

  ShopProduct({
    required this.product,
    required this.quantity,
  });

  factory ShopProduct.fromJson(Map<String, dynamic> json) {
    return ShopProduct(
      product: Product.fromJson(json['Product']),
      quantity: json['Quantity'],
    );
  }
}
