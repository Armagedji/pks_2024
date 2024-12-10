import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_market_alpha/screens/product_detail_screen.dart';
import '../models/product.dart';

class FavoriteProductsScreen extends StatelessWidget {
  final List<Product> favoriteProducts;

  const FavoriteProductsScreen({super.key, required this.favoriteProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранные продукты'),
      ),
      body: favoriteProducts.isEmpty
          ? const Center(child: Text('Нет избранных продуктов'))
          : ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Card.filled(
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                            child: favoriteProducts[index].image.startsWith('assets/')
                                ? Image.asset(
                                    favoriteProducts[index].image,
                                    fit: BoxFit.cover,
                                    height: 150,
                                  )
                                : Image.file(
                                    File(favoriteProducts[index].image),
                                    fit: BoxFit.cover,
                                    height: 150,
                                  ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  favoriteProducts[index].title,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  favoriteProducts[index].shortDescription,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetailScreen(
                                          product: favoriteProducts[index],
                                          onRemoveProduct: (product) {},
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Прочитать подробнее'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
