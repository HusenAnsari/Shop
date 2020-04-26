import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/helpers/custom_route.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/product_overview_screen.dart';
import 'package:shop/screens/splash_screen.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products_provider.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider(create: (context)) is recommended if we create of first time otherwise we use
    // ChangeNotifierProvider.value( value: )

    // Multi provider
    return MultiProvider(
      providers: [
        // All added providers.
        // Provider doesn't rebuild the widgets.
        // Pass instant of provider class.
        // Auth provider in always top on the list of all provider.
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),

        // - ChangeNotifierProxyProvider is a provider it's depend on another provider.
        //   which was defied before this one.
        // Here ProxyProvider take Auth as a param and give you the object of auth in it's update().
        // Also we get previous product data in update()
        ChangeNotifierProxyProvider<Auth, ProductProvide>(
          create: (context) => ProductProvide(),
          update: (context, auth, previousProduct) =>
          previousProduct..update(auth.token, auth.userId),
        ),
        ChangeNotifierProvider(
          //Pass instant of provider class.
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(),
          update: (context, auth, previousOrders) =>
          previousOrders..update(auth.token, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, child) =>
            MaterialApp(
              title: 'Shop',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',

                //  Using CustomRoute in route level so we can assign animation to all page.
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionsBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionsBuilder()
                }),
              ),
              home: authData.isAuth
                  ? ProductOverviewScreen()
                  : FutureBuilder(
                future: authData.tryAutoLogin(),
                builder: (context, authResult) =>
                authResult.connectionState == ConnectionState.waiting
                    ? SplashScreen()
                    : AuthScreen(),
              ),
              // Register all screen to routeTable.
              routes: {
                ProductDetailScreen.routeName: (context) =>
                    ProductDetailScreen(),
                CartScreen.routeName: (context) => CartScreen(),
                OrderScreen.routeScreen: (context) => OrderScreen(),
                UserProductScreen.routeName: (context) => UserProductScreen(),
                EditProductScreen.routeName: (context) => EditProductScreen(),
              },
            ),
      ),
    );
  }
}
