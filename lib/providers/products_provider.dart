import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

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

  // Assign Future type to addProduct() to get some data after http.post() and show loader.
  Future<void> addProduct(Product product) {
    //Firebase database URL = https://fir-product-e52b8.firebaseio.com/
    // Here we are adding "/products" to create folder / collection in firebase database.
    // We have to add ".json at the add of url because firebase need that to parse request"
    const url = 'Your Firebase database URL goes here!';

    // body: use to pass data and we need to pass json data in body.
    // json.encode convert object into json.
    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }),
    )
    // .then() execute after .post() method successfully submitted data get we get response in .than() method
        .then(
          (response) {
        // To print firebase response data.
        // json.decode(response.body) return {'name': firebase id that is in firebase database console}
        //print(json.decode(response.body));
        final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
        );
        _items.add(newProduct);
        notifyListeners();
      },
    );
  }

  void updateProduct(String id, Product newProduct) {
    final productIndex = _items.indexWhere((product) => product.id == id);
    // When we get productIndex then we assign newProduct to that index;
    if (productIndex >= 0) {
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  // Get Product detail by id.
  Product findProductById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }
}
