import 'package:flutter/material.dart';

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
        ],
      ),
      body: ProductGrid(_showFavorite),
    );
  }
}
