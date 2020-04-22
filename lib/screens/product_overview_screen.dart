import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

import '../widgets/badge.dart';
import '../widgets/product_grid.dart';

enum FilterOption {
  All,
  Favorite,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOption value) {
              setState(() {
                if (value == FilterOption.Favorite) {
                  _showFavorite = true;
                } else {
                  _showFavorite = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) =>
            [
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOption.All,
              ),
              PopupMenuItem(
                child: Text('Only Favorite'),
                value: FilterOption.Favorite,
              ),
            ],
          ),
          // - Here we only change value: that is card.itemCount.toString()) not all IconButton.
          //   so we defined card.itemCount.toString() as a child in Consumer builder
          Consumer<Cart>(
            // Here iconButtonChild in parameter is child: IconButton(_.
            builder: (context, card, iconButtonChild) =>
                Badge(
                  child: iconButtonChild,
                  value: card.itemCount.toString(),
                ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: ProductGrid(_showFavorite),
    );
  }
}
