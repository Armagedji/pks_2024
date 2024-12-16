import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';


const String _fileName = 'products.json';

Future<String> _getFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/$_fileName';
}

Future<List<Product>> loadProducts() async {
  try {
    final path = await _getFilePath();
    
    final file = File(path);

    if (await file.exists()) {
      final jsonString = await file.readAsString();
      
      final List<dynamic> jsonData;
try {
  jsonData = json.decode(jsonString);
} catch (e) {
  throw Exception('Ошибка при декодировании JSON: $e');
}

      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      final jsonString = await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    }
  } catch (e) {
    throw Exception('Ошибка при загрузке данных: $e');
  }
}

Future<void> saveProducts(List<Product> products) async {
  try {
    final path = await _getFilePath();
    final file = File(path);
    final jsonData = json.encode(products.map((product) => product.toJson()).toList());
    await file.writeAsString(jsonData);
  } catch (e) {
    throw Exception('Ошибка при сохранении данных: $e');
  }
}