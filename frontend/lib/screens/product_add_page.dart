import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_market_alpha/api/api_service.dart';

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

  void _addProduct() {
    setState(() {
    ApiService().createProduct(
      titleController.text, 
    shortDescriptionController.text,
    descriptionController.text,
    priceController.text,
    imageUrl.text);
    });
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
                  _addProduct();
                  Navigator.pop(context);
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
