import 'dart:io';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_market_alpha/models/shop_product.dart';
import 'package:flutter_market_alpha/screens/favorite_product_screen.dart';
import 'package:flutter_market_alpha/screens/profile_screen.dart';
import 'package:flutter_market_alpha/screens/shopping_screen.dart';
import '../data/data_loader.dart';
import '../models/product.dart';
import 'product_add_screen.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  List<Product> favoriteProducts = [];
  List<ShopProduct> shoppingProducts = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final loadedProducts = await loadProducts();
    setState(() {
      products = loadedProducts;
    });
  }

  Future<void> _saveProducts() async {
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
  }

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Scaffold(
        appBar: AppBar(
          title: const Text('Перечень семян'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductAddScreen(onAddProduct: _addProduct)),
                );
              },
            ),
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
        body: ListView.builder(
          itemCount: products.length,
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
                        child: products[index].image.startsWith('assets/')
                            ? Image.asset(
                                products[index].image,
                                fit: BoxFit.cover,
                                height: 150,
                              )
                            : Image.file(
                                File(products[index].image),
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
                              products[index].title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              products[index].shortDescription,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    products[index].isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: products[index].isFavorite ? Colors.red : null,
                                  ),
                                  onPressed: () => _toggleFavorite(products[index]),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_shopping_cart_rounded),
                                  onPressed: () => _addShop(products[index]),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetailScreen(
                                            product: products[index],
                                            onRemoveProduct: _removeProduct,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Прочитать подробнее'),
                                  ),
                                ),
                              ],
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
      ),
      FavoriteProductsScreen(favoriteProducts: favoriteProducts), 
      ProfileScreen()
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Продукты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранные',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
