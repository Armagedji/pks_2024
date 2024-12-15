class ShopProduct{
  final int gameId;
  int quantity;

  ShopProduct(
      {
        required this.gameId,
        required this.quantity
      }
      );

  factory ShopProduct.fromJson(Map<String, dynamic> json) {
    return ShopProduct(
      gameId: json['product_id'].toInt(),
      quantity: json['quantity'].toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': gameId,
      'quantity': quantity
    };
  }
}