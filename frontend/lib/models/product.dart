class Product{
  final int id;
  final String name;
  final String image;
  final String description;
  final String short_description;
  final double price;
  int stock;

  Product(
      {required this.id,
        required this.name,
        required this.image,
        required this.description,
        required this.short_description,
        required this.price,
        required this.stock
      });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['product_id'].toInt() ?? 0,
        name: json['name'] ?? '',
        image: json['image'] ?? '',
        description: json['description'] ?? '',
        short_description: json['short_description'] ?? '',
        price: json['price'].toDouble() ?? 0,
        stock: json['stock'].toInt() ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'name': name,
      'image': image,
      'description': description,
      'short_description': short_description,
      'price': price,
      'stock': stock
    };
  }
}