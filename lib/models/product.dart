class Product {
  final String title;
  final String image;
  final String description;
  final String shortDescription;
  final String price;
  bool isFavorite;

  Product({
    required this.title,
    required this.image,
    required this.description,
    required this.shortDescription,
    required this.price,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      image: json['image'],
      description: json['description'],
      shortDescription: json['shortDescription'],
      price: json['price'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'shortDescription': shortDescription,
      'description': description,
      'image': image,
      'price': price,
      'isFavorite': isFavorite
    };
  }
}
