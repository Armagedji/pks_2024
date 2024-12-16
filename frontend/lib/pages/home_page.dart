import 'package:flutter/material.dart';
import 'package:flutter_market_alpha/api/api_service.dart';
import 'package:flutter_market_alpha/components/product_card.dart';
import 'package:flutter_market_alpha/pages/product_detail_page.dart';
import '../components/filter.dart';
import '../functions/filter.dart';
import '../functions/search.dart';
import '../functions/sort.dart';
import '../models/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _products;
  List<Product> filteredProducts = [];
  String searchQuery = "";
  Map<String, dynamic> filters = {};
  int _sortOption = 0;

  @override
  void initState() {
    super.initState();
    _products = ApiService().getProducts();
    _products.then((data) {
      setState(() {
        filteredProducts = data;
      });
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      _applyFiltersAndSearch();
    });
  }

  void _updateFilters(Map<String, dynamic> newFilters) {
    setState(() {
      filters = newFilters;
      _applyFiltersAndSearch();
    });
  }

  void _applyFiltersAndSearch() {
    _products.then((products) {
      List<Product> results = search(products, searchQuery);

      if (filters.isNotEmpty && filters.containsKey('price')) {
        results = filter(results, filters['price'][0], filters['price'][1]);
      }
      results = sort(results, _sortOption);
      setState(() {
        filteredProducts = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Компьютерные игры',),),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _updateSearchQuery,
                    decoration: const InputDecoration(
                      hintText: 'Поиск игр...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: DropdownButton<int>(
                  value: _sortOption,
                  icon: const Icon(Icons.sort),
                  onChanged: (int? newValue) {
                      _sortOption = newValue!;
                      _applyFiltersAndSearch();
                  },
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Без сортировки')),
                    DropdownMenuItem(value: 1, child: Row(
                      children: [
                        Text('Название'),
                        Icon(Icons.arrow_upward)
                      ],
                    )),
                    DropdownMenuItem(value: 2, child: Row(
                      children: [
                        Text('Название'),
                        Icon(Icons.arrow_downward)
                      ],
                    )),
                    DropdownMenuItem(value: 3, child: Row(
                      children: [
                        Text('Стоимость'),
                        Icon(Icons.arrow_upward)
                      ],
                    )),
                    DropdownMenuItem(value: 4, child: Row(
                      children: [
                        Text('Стоимость'),
                        Icon(Icons.arrow_downward)
                      ],
                    )),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    filters = {};
                    _applyFiltersAndSearch();
                  });
                },
                child: const Text(
                  'Сбросить',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () async {
                  final newFilters = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (context) => FilterDialog(currentFilters: filters),
                  );
                  if (newFilters != null) {
                    _updateFilters(newFilters);
                  }
                },
              ),

            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: _products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (filteredProducts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Нет доступных товаров, добавьте хотя бы одну карточку',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(76, 23, 0, 1.0),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                            padding: const EdgeInsets.all(8.0),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.6,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return GestureDetector(
                      onTap: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(product: product),
                          ),
                        );
                        if (result != null && result is Product) {
                          setState(() {
                            filteredProducts[index] = result;
                          });
                        }
                      },
                      child: ProductCard(product: product, key: UniqueKey()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}