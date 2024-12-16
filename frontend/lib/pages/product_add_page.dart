import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_market_alpha/api/api_service.dart';
import 'package:flutter_market_alpha/models/product.dart';

class ProductAddPage extends StatefulWidget {

  const ProductAddPage({super.key});

  @override
  _ProductAddPageState createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController shortDescriptionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageUrl = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  void _createItem() {
      final newItem = Product(
          id: 0,
          name: titleController.text,
          image: imageUrl.text,
          description: descriptionController.text,
          short_description: shortDescriptionController.text,
          price: double.tryParse(priceController.text) ?? 0,
          stock: int.tryParse(stockController.text) ?? 0
      );
      ApiService().addProduct(newItem);
      Navigator.pop(context, newItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить продукт'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Название'),
              ),
              TextField(
                controller: shortDescriptionController,
                decoration: const InputDecoration(labelText: 'Краткое описание'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Описание'),
              ),
              TextField(
                controller: imageUrl,
                decoration: const InputDecoration(labelText: 'Изображение'),
              ),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'В стоке: '),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Цена'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isEmpty || 
                      shortDescriptionController.text.isEmpty || 
                      descriptionController.text.isEmpty || 
                      priceController.text.isEmpty ||
                      imageUrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Пожалуйста, заполните все поля и выберите изображение.')),
                    );
                    return;
                  }
                  _createItem();
                },
                child: const Text('Добавить продукт'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
