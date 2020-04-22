import 'package:flutter/material.dart';

import '../models/product.dart';

// Here we are using ChangeNotifier to notify all dependent widget that data is changed.
class ProductProvide with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    )
  ];

  // - This get() use to get list of _items.
  // - Here we are passing copy of " _items " using return [..._items].
  // - All the objects in flutter and dart is reference type.
  //   Therefor when we pass data using _items pointer user can access
  //   that pointer and access memory address of this pointers and using
  //   that pointer user can change or start editing of _items data.
  List<Product> get items {
    return [..._items];
  }

  void addProduct() {
    notifyListeners();
  }

  // Get Product detail by id.
  Product findProductById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
}