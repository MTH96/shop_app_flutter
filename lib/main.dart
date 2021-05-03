import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/products_provider.dart';
import './provider/cart.dart';
import './provider/order.dart';
import './screens/product_screen.dart';
import './screens/products_overview.dart';
import './screens/cart_screen.dart';
import './screens/order_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_user_product_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Anton',
        ),
        routes: {
          '/': (ctx) => ProductsOverviewScreen(),
          ProductScreen.routeName: (ctx) => ProductScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditUserProductScreen.routeName: (ctx) => EditUserProductScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen()
        },
      ),
    );
  }
}
