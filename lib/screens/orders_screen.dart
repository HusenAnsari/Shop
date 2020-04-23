import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  // Here we have 2 file with same name "OrderItem" so we use "show" with some name that is "import '../providers/orders.dart' show Orders;"
  // that now "../providers/orders.dart" show only Orders from orders.dart file.

  static const routeScreen = '/order_screen';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (context, index) =>
            OrderItem(
              ordersData.orders[index],
            ),
        itemCount: ordersData.orders.length,
      ),
    );
  }
}
