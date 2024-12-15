import 'package:flutter/material.dart';
import 'package:flutter_market_alpha/api/api_service.dart';
import 'package:flutter_market_alpha/models/product.dart';

class ShopCard extends StatefulWidget {
  const ShopCard({super.key, required this.product,
    required this.quantity,
    required this.onQuantityChanged,
  });
  final Product product;
  final int quantity;
  final Function(int newCounter) onQuantityChanged;
  @override
  State<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {
  void _increaseCounter() async {
    await ApiService().addToCart(widget.product.id, widget.quantity + 1);
    widget.onQuantityChanged(widget.quantity + 1);
  }

  void _decreaseCounter() async {
    if (widget.quantity > 1) {
      await ApiService().addToCart(widget.product.id, widget.quantity - 1);
      widget.onQuantityChanged(widget.quantity - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
      color: Colors.grey.withOpacity(0.4),
      width: 1,
        )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            child: ClipRRect(
                child: Image.network(widget.product.image)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.short_description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),Text(
                  '\₽${widget.product.price}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: _decreaseCounter,
                          icon: const Icon(Icons.remove)),
                      Text(
                        widget.quantity.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      IconButton(
                          onPressed: _increaseCounter,
                          icon: const Icon(Icons.add)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
