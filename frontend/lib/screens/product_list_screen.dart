import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter_market_alpha/api/api_service.dart';
import 'package:flutter_market_alpha/components/product_card.dart';
import 'package:flutter_market_alpha/models/shop_product.dart';
import 'package:flutter_market_alpha/screens/shopping_screen.dart';
import '../models/product.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> products;
  List<Product> favoriteProducts = [];
  List<ShopProduct> shoppingProducts = [];

  @override
  void initState() {
    super.initState();
    products = ApiService().getProducts();
  }

  /*Future<void> _saveProducts() async {
    try {
      await saveProducts(products);
    } catch (e) {
      print('Ошибка при сохранении данных: $e');
    }
  }

  void _addProduct(Product product) {
    setState(() {
      products.add(product);
    });
    _saveProducts();
  }

  void _removeProduct(Product product) {
    setState(() {
      products.remove(product);
    });
    _saveProducts();
  } */

  void _toggleFavorite(Product product) {
    setState(() {
      product.isFavorite = !product.isFavorite;
      if (product.isFavorite) {
        favoriteProducts.add(product);
      } else {
        favoriteProducts.remove(product);
      }
    });
  }

  void _addShop(Product product) {
  setState(() {
    var existingProduct = shoppingProducts.firstWhereOrNull(
      (shopProduct) => shopProduct.product.title == product.title);
    if (existingProduct != null) {
      existingProduct.quantity++;
    } else {
      shoppingProducts.add(ShopProduct(product, 1));
    }
  });
}

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Перечень семян'),
          actions: [
            /*IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductAddScreen(onAddProduct: _addProduct)),
                );
              },
            ),*/
            IconButton(
              icon: const Icon(Icons.shopping_basket_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShoppingScreen(shoppingProducts: shoppingProducts)),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Product>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          }
          
          final products = snapshot.data;
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Две колонки
              childAspectRatio: 0.6,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemCount: products?.length,
            itemBuilder: (context, index) {
              final product = products![index];
              return ProductCard(
                title: product.title,
                image: product.image,
                shortDescription: product.shortDescription,
                price: product.price,
                isFavorite: product.isFavorite,
                onAddToCart: () => _addShop(product),
                onToggleFavorite: () => _toggleFavorite(product),
              );
            },
          );

  })
    );
  }
}
