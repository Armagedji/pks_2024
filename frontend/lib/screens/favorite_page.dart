import 'package:flutter/material.dart';
import 'package:flutter_market_alpha/components/product_card.dart';
import '../api/api_service.dart';
import '../models/product.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  List<Product> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final allItems = await ApiService().getFavorites();
      setState(() {
        favoriteProducts = allItems;
      });
    } catch (error) {
      print("Ошибка загрузки избранных товаров: $error");
    }
  }

void _toggleFavorite(Product product) {
    setState(() {
      product.isFavorite = !product.isFavorite;
      print("Updating right now!");
      ApiService().updateFavoriteStatus(product.id, product.isFavorite);
    });
  }

  void _addShop(Product product) {
  setState(() {
    ApiService().addProductToCart(product.id);
  });
}
  void updateFavoriteStatus(Product product, bool isFavorite) {
    setState(() {
      product.isFavorite = isFavorite;
      if (isFavorite) {
        favoriteProducts.add(product);
      } else {
        favoriteProducts.remove(product);
      }
    });
    ApiService().updateFavoriteStatus(product.id, isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Избранное')),
        body: 
            GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = favoriteProducts[index];
              return ProductCard(
                product: product,
                onAddToCart: () => _addShop(product),
                onToggleFavorite: () => _toggleFavorite(product),
              );
            },
           )
    );
  }
}
