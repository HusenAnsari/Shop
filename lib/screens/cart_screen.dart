import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';

  @override
  Widget build(BuildContext context) {
    // Listener
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  // Spacer take all the available space
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color:
                          Theme
                              .of(context)
                              .primaryTextTheme
                              .title
                              .color),
                    ),
                    backgroundColor: Theme
                        .of(context)
                        .primaryColor,
                  ),
                  FlatButton(
                    child: Text(
                      'ORDER NOW',
                      style: TextStyle(color: Theme
                          .of(context)
                          .primaryColor),
                    ),
                    onPressed: () {
                      // - Here "cart.items" return Map from Cart.dart class and we need only value from Map.
                      // - so we use ".values.toList()" as .value give us the Iterable we need to convert
                      //   to List using ".toList()"
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,
                      );
                      cart.clearCart();
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            // ListView directly inside column not work that's why we use Expanded().
            child: ListView.builder(
              itemCount: cart.items.length,
              // - Here "cart.items" return Map from Cart.dart class and we need only value from Map.
              // - so we use ".values.toList()" as .value give us the Iterable we need to convert
              //   to List using ".toList()"
              itemBuilder: (context, index) =>
                  CartItem(
                    cartId: cart.items.values.toList()[index].id,
                    // Passing keys to CartIte() as a productId.
                    productId: cart.items.keys.toList()[index],
                    title: cart.items.values.toList()[index].title,
                    price: cart.items.values.toList()[index].price,
                    quantity: cart.items.values.toList()[index].quantity,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
