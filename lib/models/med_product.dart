class MedProduct {
  final String title;
  final String time;
  final String price;

  MedProduct({
    required this.title,
    required this.time,
    required this.price,
  });

  factory MedProduct.fromJson(Map<String, dynamic> json) {
    return MedProduct(
      title: json['title'],
      time: json['time'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'price': price,
    };
  }
}
