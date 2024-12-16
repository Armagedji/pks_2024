import '../models/product.dart';
// price - фильтр по минимальной и максимальной стоимости

List<Product> filter(List<Product> games, int? minPrice, int? maxPrice) {
  return games.where((game) =>
  (game.price >= minPrice! && game.price <= maxPrice!)
  ).toList();
}
