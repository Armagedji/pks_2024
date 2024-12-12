import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_market_alpha/models/shop_product.dart';

class ShoppingScreen extends StatefulWidget {
  final List<ShopProduct> shoppingProducts;

  const ShoppingScreen({super.key, required this.shoppingProducts});

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  void _updateQuantity(int index, int change) {
    setState(() {
      widget.shoppingProducts[index].quantity += change;
      if (widget.shoppingProducts[index].quantity < 1) {
        widget.shoppingProducts.removeAt(index);
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      widget.shoppingProducts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: widget.shoppingProducts.isEmpty
          ? const Center(child: Text('Ваша корзина пуста'))
          : ListView.builder(
              itemCount: widget.shoppingProducts.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(widget.shoppingProducts[index].product.title.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _removeItem(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.shoppingProducts[index].product.title} удален из корзины'),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Padding(
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
                              child: widget.shoppingProducts[index].product.image.startsWith('assets/')
                                  ? Image.asset(
                                      widget.shoppingProducts[index].product.image,
                                      fit: BoxFit.cover,
                                      height: 150,
                                    )
                                  : Image.file(
                                      File(widget.shoppingProducts[index].product.image),
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
                                    widget.shoppingProducts[index].product.title,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => _updateQuantity(index, -1),
                                        icon: const Icon(Icons.remove),
                                      ),
                                      Text(widget.shoppingProducts[index].quantity.toString()),
                                      IconButton(
                                        onPressed: () => _updateQuantity(index, 1),
                                        icon: const Icon(Icons.add),
                                      ),
                                      Text('Цена: ${widget.shoppingProducts[index].quantity * int.parse(widget.shoppingProducts[index].product.price)}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
