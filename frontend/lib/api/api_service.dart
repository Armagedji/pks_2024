import 'package:dio/dio.dart';
import '/models/product.dart';
import '/models/shop_product.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'http://127.0.0.1:8080';

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('$baseUrl/products');
      if (response.statusCode == 200) {
        List<Product> products = (response.data as List)
            .map((product) => Product.fromJson(product))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await _dio.get('$baseUrl/products/$id');
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        throw Exception('Product not found');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  Future<Product> createProduct(String title, String shortDescription, String description, String price, String imageUrl) async {
    try {
      final response = await _dio.post(
        '$baseUrl/products/create',
        data: {'title': title,'shortDescription': shortDescription,'description':description,'price':price, 'imageUrl':imageUrl,'isFavorite': false},
      );
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        throw Exception('Failed to create product');
      }
    } catch (e) {
      throw Exception('Error creating product: $e');
    }
  }

  Future<Product> updateProduct(int id, Product product) async {
    try {
      final response = await _dio.put(
        '$baseUrl/products/update/$id',
        data: product.toJson(),
      );
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await _dio.delete('$baseUrl/products/delete/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }

  Future<List<Product>> getFavorites() async {
    try {
      final response = await _dio.get('$baseUrl/favorite');
      if (response.statusCode == 200) {
        List<Product> favorites = (response.data as List)
            .map((product) => Product.fromJson(product))
            .toList();
        return favorites;
      } else {
        throw Exception('Failed to load favorites');
      }
    } catch (e) {
      throw Exception('Error fetching favorites: $e');
    }
  }

  Future<Product> updateFavoriteStatus(int id, bool isFavorite) async {
    try {
      final response = await _dio.put(
        '$baseUrl/favorite/update/$id',
        data: {'isFavorite': isFavorite},
      );
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        throw Exception('Failed to update favorite status');
      }
    } catch (e) {
      throw Exception('Error updating favorite status: $e');
    }
  }

  Future<List<ShopProduct>> getCart() async {
    try {
      final response = await _dio.get('$baseUrl/cart');
      if (response.statusCode == 200) {
        List<ShopProduct> cart = (response.data as List)
            .map((shopProduct) => ShopProduct.fromJson(shopProduct))
            .toList();
        return cart;
      } else {
        throw Exception('Failed to load cart');
      }
    } catch (e) {
      throw Exception('Error fetching cart: $e');
    }
  }

  Future<ShopProduct> addProductToCart(int id) async {
    try {
      final response = await _dio.post('$baseUrl/cart/add/$id');
      if (response.statusCode == 200) {
        return ShopProduct.fromJson(response.data);
      } else {
        throw Exception('Failed to add product to cart');
      }
    } catch (e) {
      throw Exception('Error adding product to cart: $e');
    }
  }

  Future<void> deleteProductFromCart(int id) async {
    try {
      final response = await _dio.delete('$baseUrl/cart/delete/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete product from cart');
      }
    } catch (e) {
      throw Exception('Error deleting product from cart: $e');
    }
  }

  Future<ShopProduct> increaseProductQuantity(int id) async {
    try {
      final response = await _dio.put('$baseUrl/cart/increase/$id');
      if (response.statusCode == 200) {
        return ShopProduct.fromJson(response.data);
      } else {
        throw Exception('Failed to increase product quantity');
      }
    } catch (e) {
      throw Exception('Error increasing product quantity: $e');
    }
  }

  Future<ShopProduct> decreaseProductQuantity(int id) async {
    try {
      final response = await _dio.put('$baseUrl/cart/decrease/$id');
      if (response.statusCode == 200) {
        return ShopProduct.fromJson(response.data);
      } else {
        throw Exception('Failed to decrease product quantity');
      }
    } catch (e) {
      throw Exception('Error decreasing product quantity: $e');
    }
  }

  Future<int> getCartPrice() async {
  try {
    final response = await _dio.get('$baseUrl/cart/price');
    if (response.statusCode == 200) {
      return response.data['totalPrice'];
    } else {
      throw Exception('Failed to load cart price');
    }
  } catch (e) {
    throw Exception('Error fetching cart price: $e');
  }
}
}
