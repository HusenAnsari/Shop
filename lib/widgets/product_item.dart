import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //get data using Provider which is sanded from "ProductGrid" class.
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    // We can also use Consumer instead of "Provider.of"
    // When we run Provider.of all build() re-run when data change;
    // Rounded corner using ClipRRect().
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            // Forward id to "ProductDetailScreen"
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),

        // To display amount in header.
        //header: Text('10'),

        footer: GridTileBar(
          // When we want to change  part of the widget tree we use Consumer() to reBuild widget.
          leading: Consumer<Product>(
            builder: (context, product, child) =>
                IconButton(
                  color: Theme
                      .of(context)
                      .accentColor,
                  icon: Icon(
                      product.isFavorite ? Icons.favorite : Icons
                          .favorite_border),
                  onPressed: () {
                    product.toggleFavoriteStatus();
                  },
                ),
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
            },
          ),
        ),
      ),
    );
  }
}
