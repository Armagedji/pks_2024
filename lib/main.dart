import 'package:flutter/material.dart';
import 'models/product.dart';
import 'data/data_loader.dart';
import '../screens/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Список семян',
      theme: ThemeData(
        primaryColor: const Color(0xFF2D4059),
        scaffoldBackgroundColor: const Color(0xFFFFD151),
        cardColor: const Color(0xFFEDB230),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE77728),
            foregroundColor: const Color(0xFF1B262C),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Color(0xFF1B262C), fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Color(0xFF1B262C), fontSize: 16.0),
          bodyMedium: TextStyle(color: Color(0xFF4E4E50), fontSize: 14.0),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE77728),
        ),
      ),
      home: FutureBuilder<List<Product>>(
  future: loadProducts(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      print('Ошибка при загрузке данных: ${snapshot.error}');
      return const Center(child: Text('Ошибка при загрузке информации'));
    } else if (snapshot.hasData) {
      return ProductListScreen();
    } else {
      return const Center(child: Text('Нет данных'));
    }
  },
),
    );
  }
}