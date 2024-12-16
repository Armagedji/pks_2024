
import 'package:flutter_market_alpha/models/product.dart';

List<Product> search (List<Product> games, String query){
  List<Product> result = [];
  result = games.where((game) => game.name.toLowerCase().contains(query.toLowerCase()) || game.description.toLowerCase().contains(query.toLowerCase())).toList();
  return result;
}