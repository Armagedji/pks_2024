import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_market_alpha/api/api_service.dart';
import 'package:flutter_market_alpha/main.dart';
import 'package:flutter_market_alpha/models/product.dart';
import 'package:flutter_market_alpha/pages/product_detail_page.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late Product product;
  bool isFavorite = false;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    product = widget.product;
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      final response = await dio.get(
        'http://127.0.0.1:8080/favorites/$globalProfileId/${widget.product.id}',
      );
      setState(() {
        isFavorite = response.statusCode == 200;
      });
    } catch (e) {
      print("Ошибка проверки статуса избранного: $e");
    }
  }

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
                  product.name,
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
                  product.short_description,
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
                onPressed: () async {
                              await ApiService().addToCart(product.id, 1);
                            },
                icon: const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: Colors.black,
                ),
                onPressed: () async {
                      if(isFavorite){
                        await ApiService().removeFromFavorites(widget.product.id);
                      }
                      else{
                        await ApiService().addToFavorites(widget.product.id);
                      }
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
