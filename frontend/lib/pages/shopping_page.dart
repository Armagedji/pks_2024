import 'package:flutter/material.dart';
import 'package:flutter_market_alpha/api/api_service.dart';
import 'package:flutter_market_alpha/components/shop_card.dart';
import 'package:flutter_market_alpha/main.dart';
import 'package:flutter_market_alpha/models/order.dart';
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

  // Преобразуем список ShopProduct в список Product
  List<Product> _convertShopProductsToProducts(List<ShopProduct> cartItems, List<Product> products) {
    return cartItems.map((cartItem) {
      // Находим соответствующий Product для ShopProduct по gameId
      final product = products.firstWhere((product) => product.id == cartItem.gameId);
      return Product(
        id: product.id,
        name: product.name,
        price: product.price, 
        image: product.image,
        description: product.description,
        short_description: product.short_description,
        stock: product.stock
      );
    }).toList();
  }

  Future<void> _createOrder(double totalPrice, List<ShopProduct> cartItems) async {
    try {
      final products = await _products;
      
      // Преобразуем ShopProduct в Product
      final productList = _convertShopProductsToProducts(cartItems, products);

      await ApiService().createOrder(Order(
        orderId: 0,
        userId: globalProfileId,
        total: totalPrice,
        status: '',
        products: productList,  // Передаем список типа List<Product>
      ));

      // Очищаем корзину после оформления заказа
      await ApiService().clearBasket(cartItems);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Заказ оформлен!'),
          content: const Text(
            'Ваш заказ успешно отправлен, корзина очищена.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      setState(() {
        _cart = ApiService().getCart();  // Обновляем корзину
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ошибка'),
          content: Text('Не удалось оформить заказ: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
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
                        final product = products.firstWhere(
                            (p) => p.id == cartItem.gameId,
                            orElse: () => Product(id: 0, name: '', price: 0, image: '', description: '', short_description: '', stock: 0)); // Защита от ошибок
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
                              });
                            },
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

                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 20.0),
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: GestureDetector(
                              onTap: () async {
                                final basketItems = cartSnapshot.data!;
                                final total = priceSnapshot.data ?? 0;
                                await _createOrder(total, basketItems);
                              },
                              child: Container(
                                width: 330,
                                height: 35,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromRGBO(129, 40, 0, 1),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Оформить заказ',
                                    style: TextStyle(
                                      color: Color.fromRGBO(129, 40, 0, 1),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
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
