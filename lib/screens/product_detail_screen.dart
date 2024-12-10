import 'dart:io';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final Function(Product) onRemoveProduct;

  const ProductDetailScreen({super.key, required this.product, required this.onRemoveProduct});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: Text(
                    'Удалить продукт?',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  content: Text(
                    'Вы уверены, что хотите удалить этот продукт?',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Отмена',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        onRemoveProduct(product);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Удалить',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product.image.startsWith('assets/')
                ? Image.asset(product.image)
                : Image.file(File(product.image)),
            const SizedBox(height: 16),
            Text(
              product.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
