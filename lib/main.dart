import 'package:flutter/material.dart';
import 'models/med_product.dart';
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
      title: 'Медицина',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(26, 111, 238, 100),
          primary: const Color.fromRGBO(26, 111, 238, 100),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
        appBarTheme: const AppBarTheme(color: Colors.white),
        fontFamily: 'Montserrat',
      ),
      home: FutureBuilder<List<MedProduct>>(
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