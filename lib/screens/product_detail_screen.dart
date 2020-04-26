import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product_detail_screen';

  @override
  Widget build(BuildContext context) {
    // Receive id sanded from "ProductItem" page.
    // Listener
    // Listener rebuild the widgets.
    String productId = ModalRoute.of(context).settings.arguments;

    // - Get Product detail using provide using "productId".
    // - Above build method rebuild if some where new product added
    //   this not impact in this screen if some how it visible. To solve this problem we
    //   need to add listen: false in of<ProductProvide>(context, listen: false).
    // - After added listen to false build() rebuild only first time when screen load.
    final loadedProduct = Provider.of<ProductProvide>(context, listen: false)
        .findProductById(productId);

    return Scaffold(
      /* appBar: AppBar(
        title: Text(loadedProduct.title),
      ),*/
      body: CustomScrollView(
        // silvers are the scrollable are on the screen
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Container(
                height: 300,
                width: double.infinity,
                child: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                Text(
                  '\$${loadedProduct.price}',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
