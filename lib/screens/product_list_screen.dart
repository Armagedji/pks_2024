import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_market_alpha/models/shop_product.dart';
import 'package:flutter_market_alpha/screens/profile_screen.dart';
import 'package:flutter_market_alpha/screens/shopping_screen.dart';
import '../data/data_loader.dart';
import '../models/med_product.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<MedProduct> products = [];
  List<ShopProduct> shoppingProducts = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final loadedProducts = await loadProducts();
    setState(() {
      products = loadedProducts;
    });
  }

  void _addShop(MedProduct product) {
  setState(() {
    var existingProduct = shoppingProducts.firstWhereOrNull(
      (shopProduct) => shopProduct.product.title == product.title);
    if (existingProduct != null) {
      existingProduct.quantity++;
    } else {
      shoppingProducts.add(ShopProduct(product, 1));
    }
  });
}

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Scaffold(
        appBar: AppBar(
          title: const Text(
            'Каталог услуг',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          titleSpacing: 27,
        ),
        body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Container(
                height: 136,
                margin: const EdgeInsets.fromLTRB(27.5, 0, 27.5, 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration( borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(color: const Color.fromRGBO(224, 224, 224, 100),),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              products[index].title,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    products[index].time,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(147, 147, 150, 100),
                    ),
                  ),
                  Text(
                    '${products[index].price} ₽',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () => _addShop(products[index]),
                child: Container(
                  width: 96,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Center(
                    child: Text(
                      'Добавить',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),],),
              ),
            );
          },
        ),
      ),
      ShoppingScreen(shoppingProducts: shoppingProducts), 
      ProfileScreen()
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/home.png'),
            activeIcon: Image.asset('assets/images/home_active.png'),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/cart.png'),
            activeIcon: Image.asset('assets/images/cart_active.png'),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/profile.png',),
            activeIcon: Image.asset('assets/images/profile_active.png'),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
