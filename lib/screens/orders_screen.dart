import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/order_item.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  // Here we have 2 file with same name "OrderItem" so we use "show" with some name that is "import '../providers/orders.dart' show Orders;"
  // that now "../providers/orders.dart" show only Orders from orders.dart file.

  static const routeScreen = '/order_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) =>
                    ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (context, index) =>
                          OrderItem(
                            orderData.orders[index],
                          ),
                    ),
              );
            }
          }
        },
      ),
    );
  }
}
