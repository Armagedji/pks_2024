import 'package:flutter/material.dart';
import 'package:flutter_market_alpha/models/product.dart';
import 'package:flutter_market_alpha/screens/product_detail_page.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function() onAddToCart;
  final Function() onToggleFavorite;

  const ProductCard({
    Key? key,
    required this.product,
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
          SizedBox(
            height: 70,
            child: Image.network(
              product.image,
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
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\₽${product.price}',
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
                  product.shortDescription,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, 
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                        product: product,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.info,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: onAddToCart,
                icon: const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: Colors.black,
                ),
                onPressed: onToggleFavorite,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
