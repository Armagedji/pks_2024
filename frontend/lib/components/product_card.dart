import 'package:flutter/material.dart';

// Новый виджет для отображения карточки товара
class ProductCard extends StatelessWidget {
  final String title;
  final String image;
  final String shortDescription;
  final String price;
  final bool isFavorite;
  final Function() onAddToCart;
  final Function() onToggleFavorite;

  const ProductCard({
    Key? key,
    required this.title,
    required this.image,
    required this.shortDescription,
    required this.price,
    required this.isFavorite,
    required this.onAddToCart,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Увеличиваем высоту изображения
          SizedBox(
            height: 70, // Увеличиваем высоту изображения
            child: Image.network(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\₽${price}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  shortDescription,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Выравнивание кнопок по центру
            children: [
              IconButton(
                onPressed: onAddToCart,
                icon: const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_outline,
                  color: Colors.black,
                ),
                onPressed: () => onToggleFavorite,
              ),
            ],
          ),
        ],
      ),
    );
  }
}




