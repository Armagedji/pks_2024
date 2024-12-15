import 'package:flutter/material.dart';
import 'package:flutter_market_alpha/api/api_service.dart';
import 'package:flutter_market_alpha/components/shop_card.dart';
import 'package:flutter_market_alpha/models/product.dart';
import 'package:flutter_market_alpha/models/shop_product.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  late Future<List<Product>> _products;
  late Future<List<ShopProduct>> _cart;
  late Future<double> totalPrice;

  @override
  void initState() {
    super.initState();
    _products = ApiService().getProducts();
    _cart = ApiService().getCart();
    totalPrice = _calculateTotalPrice();
  }

  Future<double> _calculateTotalPrice() async {
    final cartItems = await _cart;
    final products = await _products;

    double total = 0;
    for (var cartItem in cartItems) {
      final product = products.firstWhere((p) => p.id == cartItem.gameId);
      total += product.price * cartItem.quantity;
    }

    return total;
  }


  Future<void> _deleteGame(int id) async {
    await ApiService().removeFromCart(id);
                  setState(() {
                    _cart = ApiService().getCart();
                    totalPrice = _calculateTotalPrice();
                  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: FutureBuilder<List<ShopProduct>>(
        future: _cart,
        builder: (context, cartSnapshot) {
          if (cartSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!cartSnapshot.hasData || cartSnapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Ваша корзина пуста',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(76, 23, 0, 1.0),
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
              return Column(
        children: [
          Expanded(
            child: ListView.builder(
                    itemCount: cartSnapshot.data!.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartSnapshot.data![index];
                      final product = products.firstWhere((p) => p.id == cartItem.gameId);
                      return Dismissible(
                        key: Key(product.id.toString()),
                        confirmDismiss: (direction) async {
                          _deleteGame(cartItem.gameId);
                          return false;
                        },
                        child: ShopCard(
                          product: product,
                          quantity: cartItem.quantity,
                           onQuantityChanged: (newCounter) {
                            setState(() {
                              cartItem.quantity = newCounter;
                              totalPrice = _calculateTotalPrice(); 
                            });}
                        ),
                      );
                    },
                  ),
          ),
          FutureBuilder<double>(
                    future: totalPrice,
                    builder: (context, priceSnapshot) {
                      if (priceSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.green[600],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Итоговая цена: ${priceSnapshot.data ?? 0}',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ));
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}