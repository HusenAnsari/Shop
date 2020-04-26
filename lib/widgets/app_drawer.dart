import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/orders_screen.dart';

import '../providers/auth.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello'),
            // Below line never add a back button
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              // Using '/' we go to route route of the app(Home page).
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Orders'),
            onTap: () {
              // Using we navigate to OrderScreen.
              Navigator.of(context)
                  .pushReplacementNamed(OrderScreen.routeScreen);

              /* // Using CustomRoute in class level
              Navigator.of(context).pushReplacement(
                  CustomRoute(builder: (ctx) => OrderScreen()));*/
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              // Using we navigate to OrderScreen.
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              // - when we all .logout() navigation drawer still open and give
              //   you error so we need to close drawer using Navigator.
              // - To Close Drawer.
              Navigator.of(context).pop();
              // Using pushReplacementNamed('/') we are redirect to Home Route and load  "home:" in main.dart file.
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
