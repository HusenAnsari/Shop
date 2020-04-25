import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

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
  String token;

  List<OrderItem> get orders {
    return [..._orders];
  }

  void update(String authToken) {
    token = authToken;
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://fir-product-e52b8.firebaseio.com/orders.json?auth=$token';
    final response = await http.get(url);
    // Response:
    // {-M5gkcgUyQWHHOZYoHuX: {amount: 111.99, dateTime: 2020-04-24T20:45:59.063036,
    // product: [{id: 2020-04-24 20:45:51.351272, price: 11.0, quantity: 1, title: Books},
    //           {id: 2020-04-24 20:45:54.647745, price: 100.99, quantity: 1, title: Aeroplane}]}}
    //print(json.decode(response.body));
    final List<OrderItem> loadedData = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedData.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          product: (orderData['product'] as List<dynamic>)
              .map(
                (items) =>
                CartItem(
                  id: items['id'],
                  price: items['price'],
                  title: items['title'],
                  quantity: items['quantity'],
                ),
          )
              .toList(),
        ),
      );
    });
    _orders = loadedData.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    // - Here we insert 0 as a index into _orders.insert(0, ) because
    //   we need to recent order as beginning of the orderList;
    final url =
        'https://fir-product-e52b8.firebaseio.com/orders.json?auth=$token';
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'product': cartProduct
            .map((cp) =>
        {
          'id': cp.id,
          'title': cp.title,
          'quantity': cp.quantity,
          'price': cp.price,
        })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          product: cartProduct,
          dateTime: timeStamp),
    );
    notifyListeners();
  }
}
