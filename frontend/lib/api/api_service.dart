import 'package:dio/dio.dart';
import 'package:flutter_market_alpha/main.dart';
import 'package:flutter_market_alpha/models/favorite.dart';
import 'package:flutter_market_alpha/models/product.dart';
import 'package:flutter_market_alpha/models/shop_product.dart';
import 'package:flutter_market_alpha/models/user.dart';

import '../models/order.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('http://127.0.0.1:8080/products');
      if (response.statusCode == 200) {
        List<Product> games = (response.data as List)
            .map((game) => Product.fromJson(game))
            .toList();

        return games;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<Product> getProductById(int gameId) async {
    try {
      final response = await _dio.get('http://127.0.0.1:8080/products/$gameId');
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> addProduct(Product item) async {
    try {
      final response = await _dio.post(
        'http://127.0.0.1:8080/products',
        data: item.toJson(),
      );
      print(item.toJson().toString());
      if (response.statusCode == 201) {
        print('Product added successfully');
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await _dio.delete(
        'http://127.0.0.1:8080/products/$id',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete item');
      }
    } catch (e) {
      throw Exception('Error deleting item: $e');
    }
  }

  Future<void> updateGameInfo(int id, Product item) async {
    try {
      final response = await _dio.put(
        'http://127.0.0.1:8080/products/$id',
        data: item.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update information');
      }
    } catch (e) {
      throw Exception('Error updating information: $e');
    }
  }

  Future<User> getUser(String email) async {
    try {
      final response = await _dio.get('http://127.0.0.1:8080/user/$email');

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<ShopProduct>> getCart() async {
    try {
      final response = await _dio.get('http://127.0.0.1:8080/cart/$globalProfileId');
      if (response.statusCode == 200) {
        print("Cart Response: ${response.data}");
        List<ShopProduct> cart = (response.data as List)
            .map((item) => ShopProduct.fromJson(item))
            .toList();

        return cart;
      } else {
        throw Exception('Failed to load cart');
      }
    } catch (e) {
      throw Exception('Error fetching cart: $e');
    }
  }

  Future<void> clearBasket(List<ShopProduct> shopProducts) async {
    for (var product in shopProducts) {
      await removeFromCart(product.gameId );
    }
  }

  Future<void> addToCart(int gameId, int counter) async {
    await _dio.post('http://127.0.0.1:8080/cart/$globalProfileId', data: {"product_id": gameId, "quantity": counter});
  }

  Future<void> removeFromCart(int gameId) async {
    await _dio.delete('http://127.0.0.1:8080/cart/$globalProfileId/$gameId');
  }

  Future<List<Favorite>> getFavorites() async {
    try {
      final response = await _dio.get('http://127.0.0.1:8080/favorites/$globalProfileId');
      if (response.statusCode == 200) {
        print("Cart Response: ${response.data}");
        List<Favorite> favorites = (response.data as List)
            .map((item) => Favorite.fromJson(item))
            .toList();

        return favorites;
      } else {
        throw Exception('Failed to load cart');
      }
    } catch (e) {
      throw Exception('Error fetching cart: $e');
    }
  }

  Future<void> addToFavorites(int gameId) async {
    await _dio.post('http://127.0.0.1:8080/favorites/$globalProfileId', data: {"product_id": gameId});
  }
  
  Future<void> removeFromFavorites(int gameId) async {
    await _dio.delete('http://127.0.0.1:8080/favorites/$globalProfileId/$gameId');
  }

  Future<void> addUser(String email, String password) async {
    try {
      final response = await _dio.post(
        'http://127.0.0.1:8080/user', 
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 201) {
        print('User added successfully');
      } else {
        throw Exception('Failed to add user');
      }
    } catch (e) {
      throw Exception('Error adding user: $e');
    }
  }

  //получение списка заказов
  Future<List<Order>> getOrders() async {
    print("getOrders function called id=$globalProfileId");
    try {
      final response =
          await _dio.get('http://127.0.0.1:8080/orders/$globalProfileId');
      if (response.statusCode == 200) {
        List<Order> orders = (response.data as List)
            .map((product) => Order.fromJson(product))
            .toList();
        return orders;
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }

  //создание заказа
  Future<void> createOrder(Order order) async {
    print("createOrder function called total=${order.total}");
    print(
        "createOrder function called order.products[0].id=${order.products[0].id}");
    try {
      final response = await _dio.post(
        'http://127.0.0.1:8080/orders/${globalProfileId}',
        data: order.toJson(),
      );
      print(order.toJson());
      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }


}