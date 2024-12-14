import 'package:flutter/material.dart';
import 'package:flutter_market_alpha/api/api_service.dart';
import 'package:flutter_market_alpha/components/shop_card.dart';
import 'package:flutter_market_alpha/models/shop_product.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  List<ShopProduct> shoppingProducts = [];
  int? priceAll;

  @override
  void initState() {
    super.initState();
    loadShop();
  }

  Future<void> loadShop() async {
    try {
      final allItems = await ApiService().getCart();
      final total = await ApiService().getCartPrice();
      setState(() {
        shoppingProducts = allItems;
        priceAll = total;
      });
    } catch (error) {
      print("Ошибка загрузки товаров корзины: $error");
    }
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      shoppingProducts[index].quantity += change;
      if (shoppingProducts[index].quantity < 1) {
        shoppingProducts.removeAt(index);
      }
      priceAll = _calculateTotalPrice();
    });
  }

  int _calculateTotalPrice() {
    int total = 0;
    for (var product in shoppingProducts) {
      total += int.parse(product.product.price) * product.quantity;
    }
    return total;
  }

  Future<void> _deleteGame(int id) async {
    await ApiService().deleteProductFromCart(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: Column(
        children: [
          Expanded(
            child: shoppingProducts.isEmpty
                ? const Center(child: Text('Ваша корзина пуста'))
                : ListView.builder(
                    itemCount: shoppingProducts.length,
                    itemBuilder: (context, index) {
                      ShopProduct product = shoppingProducts[index];
                      return Dismissible(
                        key: Key(product.product.id.toString()),
                        confirmDismiss: (direction) async {
                          await _deleteGame(product.product.id);
                          setState(() {
                            shoppingProducts.removeAt(index);
                            priceAll = _calculateTotalPrice();
                          });
                          return false;
                        },
                        child: ShopCard(
                          product: product,
                          quantity: product.quantity,
                          onQuantityChanged: (newCounter) {
                            _updateQuantity(index, newCounter - product.quantity);
                          },
                        ),
                      );
                    },
                  ),
          ),
          if (priceAll != null) 
            Container(
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
                'Итоговая цена: ${priceAll ?? 0}',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
