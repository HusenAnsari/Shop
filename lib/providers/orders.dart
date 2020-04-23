import 'package:flutter/cupertino.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> product;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.product,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProduct, double total) {
    // - Here we insert 0 as a index into _orders.insert(0, ) because
    //   we need to recent order as begining of the orderList;
    _orders.insert(
      0,
      OrderItem(
          id: DateTime.now().toString(),
          amount: total,
          product: cartProduct,
          dateTime: DateTime.now()),
    );
    notifyListeners();
  }
}
