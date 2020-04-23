import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user_product_screen';

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvide>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (context, index) =>
              Column(
                children: <Widget>[
                  UserProductItem(
                    productData.items[index].id,
                    productData.items[index].title,
                    productData.items[index].imageUrl,
                  ),
                  Divider(),
                ],
              ),
          itemCount: productData.items.length,
        ),
      ),
    );
  }
}
