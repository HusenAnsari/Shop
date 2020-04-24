import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products_provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
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
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Provider.of<ProductProvide>(context).fetchAndSetProduct(); //it's not work here as we don't have context in initState().

    /* // we can do this with Future but it's not good
    Future.delayed(Duration.zero).then((_) {
      Provider.of<ProductProvide>(context).fetchAndSetProduct();
    });*/
  }

  // It's execute after widget initialize and before build() execute.
  // That's why we use than()
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvide>(context).fetchAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
  }

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
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ProductGrid(_showFavorite),
    );
  }
}
