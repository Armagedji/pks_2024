import 'package:flutter/material.dart';
import 'package:flutter_market_alpha/api/api_service.dart';
import 'package:flutter_market_alpha/components/product_card.dart';
import 'package:flutter_market_alpha/models/favorite.dart';
import 'package:flutter_market_alpha/models/product.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<Product>> _products;
  late Future<List<Favorite>> _favorites;

  @override
  void initState() {
    super.initState();
    _products = ApiService().getProducts();
    _favorites = ApiService().getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Избранное')),
      body: FutureBuilder(
          future: _favorites,
          builder: (context, favoritesSnapshot){
            if (favoritesSnapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }
            if (!favoritesSnapshot.hasData || favoritesSnapshot.data!.isEmpty){
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 20.0,
                    left: 20.0,
                  ),
                  child: Text(
                    'У Вас нет избранных игр',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(76, 23, 0, 1.0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return FutureBuilder<List<Product>>(
              future: _products,
              builder: (context, productSnapshot) {
                if (productSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                }
                final products = productSnapshot.data!;
                return GridView.builder(
                            padding: const EdgeInsets.all(8.0),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.6,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                            ),
                  itemCount: favoritesSnapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = favoritesSnapshot.data![index];
                    final product = products.firstWhere((p) => p.id == item.gameId);
                    return ProductCard(
                        product: product,
                    );
                  },
                );
              }
            );
          })

    );
  }
}