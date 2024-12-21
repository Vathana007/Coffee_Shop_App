import 'package:coffee_shop_app/model/product_stock.dart';

class Order {
  final String id;
  final Product product;
  final int quantity;
  final String size;

  Order({
    required this.id,
    required this.product,
    required this.quantity,
    required this.size,
  });
}
