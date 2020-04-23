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
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
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
            )
          ],
        ),
      ),
    );
  }
}
