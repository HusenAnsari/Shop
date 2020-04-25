import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

import './product.dart';

// Here we are using ChangeNotifier to notify all dependent widget that data is changed.
class ProductProvide with ChangeNotifier {
  List<Product> _items = [
    /* Product(
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
    )*/
  ];

  String authToken;

  void update(String token) {
    authToken = token;
  }

  //ProductProvide(this.authToken, this._items);
  // - This get() use to get list of _items.
  // - Here we are passing copy of " _items " using return [..._items].
  // - All the objects in flutter and dart is reference type.
  //   Therefor when we pass data using _items pointer user can access
  //   that pointer and access memory address of this pointers and using
  //   that pointer user can change or start editing of _items data.
  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProduct() async {
    final url =
        'https://fir-product-e52b8.firebaseio.com/products.json?auth=$authToken';
    try {
      // Firebase return a Map in response
      // {-M5fUhSvRA4ZKVayjMMJ: {description: Book with great content., imageUrl: https://homepages.cae.wisc.edu/~ece533/images/airplane.png, isFavorite: false, price: 11.22, title: Book},
      //  -M5fUw5vtKbJ1XyP-JCL: {description: Aeroplane with great features., imageUrl: https://homepages.cae.wisc.edu/~ece533/images/airplane.png, isFavorite: false, price: 100.99, title: Aeroplane}}
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProduct = [];
      extractedData.forEach((prodId, productData) {
        loadedProduct.add(
          Product(
            id: prodId,
            title: productData['title'],
            description: productData['description'],
            imageUrl: productData['imageUrl'],
            price: productData['price'],
            isFavorite: productData['isFavorite'],
          ),
        );
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // Assign Future type to addProduct() to get some data after http.post() and show loader.
  // When we use async automatically all code of this function wrap in Future. that's now we no need to return future.
  Future<void> addProduct(Product product) async {
    //Firebase database URL = https://"...".firebaseio.com/
    // Here we are adding "/products" to create folder / collection in firebase database.
    // We have to add ".json at the add of url because firebase need that to parse request"
    final url =
        'https://fir-product-e52b8.firebaseio.com/products.json?auth=$authToken';
    // body: use to pass data and we need to pass json data in body.
    // json.encode convert object into json.
    // await finish http method first
    try {
      // we only use await with async
      // here we pass url and data we need to store.
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      // We also need to save data locally to oyr list.
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    // Passing id to URL
    // When we get productIndex then we assign newProduct to that index;
    if (productIndex >= 0) {
      final url =
          'https://fir-product-e52b8.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          },
        ),
      );
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    /* final url = 'https://fir-product-e52b8.firebaseio.com/products/$id.json';
    await http.delete(url);
    _items.removeWhere((product) => product.id == id);
    notifyListeners();*/

    final url =
        'https://fir-product-e52b8.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
    _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }

  // Get Product detail by id.
  Product findProductById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }
}
