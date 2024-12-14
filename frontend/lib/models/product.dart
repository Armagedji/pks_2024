class Product {
  final int id;
  final String title;
  final String image;
  final String description;
  final String shortDescription;
  final String price;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.shortDescription,
    required this.price,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['ID'],
      title: json['Title'],
      image: json['Image'],
      description: json['Description'],
      shortDescription: json['ShortDescription'],
      price: json['Price'],
      isFavorite: json['IsFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'shortDescription': shortDescription,
      'description': description,
      'image': image,
      'price': price,
      'isFavorite': isFavorite
    };
  }
}
