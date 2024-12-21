import 'package:coffee_shop_app/model/order_product.dart';

// order_history.dart
class OrderHistory {
  static final OrderHistory _instance = OrderHistory._internal();
  final List<Order> _orders = [];

  factory OrderHistory() {
    return _instance;
  }

  OrderHistory._internal();

  List<Order> get orders => List.unmodifiable(_orders);

  void addOrder(Order order) {
    _orders.add(order);
  }
}
