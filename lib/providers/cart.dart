import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({this.id, this.title, this.quantity, this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      // update() contain existingItem value.
      _items.update(
        productId,
            (existingItem) =>
            CartItem(
              // Value assign same only quantity update with 1.
              id: existingItem.id,
              title: existingItem.title,
              price: existingItem.price,
              quantity: existingItem.quantity + 1,
            ),
      );
    } else {
      _items.putIfAbsent(
        productId,
            () =>
            CartItem(
                title: title,
                id: DateTime.now().toString(),
                price: price,
                quantity: 1),
      );
    }
    notifyListeners();
  }
}
