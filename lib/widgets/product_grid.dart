import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorite;

  ProductGrid(this.showFavorite);

  @override
  Widget build(BuildContext context) {
    // Provider listener if data change.
    // Here in of<ProductProvide> provider listener check is data change in ProductProvide.
    // Here "productData" give the access object of ProductProvide object.
    final productData = Provider.of<ProductProvide>(context);

    // Here we get list of items from "productData" that is ProductProvide object.
    final products =
    showFavorite ? productData.favoriteItems : productData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,

      //Pass data using Provider to "ProductItem" class.
      // As we are not using context in create: (context) => ProductProvide(),
      // So we can simple remove using ChangeNotifierProvider.value as this Constructor simple take value argument..
      // Is recommended to use ChangeNotifierProvider.value() with value / object already exist.
      itemBuilder: (context, index) =>
          ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItem(),
          ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
