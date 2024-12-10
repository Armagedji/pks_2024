class Product {
  final String title;
  final String image;
  final String description;
  final String shortDescription;
  bool isFavorite;

  Product({
    required this.title,
    required this.image,
    required this.description,
    required this.shortDescription,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      image: json['image'],
      description: json['description'],
      shortDescription: json['shortDescription'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'shortDescription': shortDescription,
      'description': description,
      'image': image,
      'isFavorite': isFavorite
    };
  }
}
