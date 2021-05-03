import 'package:flutter/material.dart';

import '../screens/user_product_screen.dart';
import '../screens/order_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('MyShop'),
            automaticallyImplyLeading: false,
          ),
          RouteDrawer(
            icon: Icons.shop,
            routeName: '/',
            title: 'Shop',
          ),
          RouteDrawer(
            icon: Icons.payment,
            routeName: OrderScreen.routeName,
            title: 'Your Orders',
          ),
          RouteDrawer(
            icon: Icons.edit,
            routeName: UserProductScreen.routeName,
            title: 'User Products',
          ),
        ],
      ),
    );
  }
}

class RouteDrawer extends StatelessWidget {
  final String title;
  final String routeName;
  final IconData icon;

  const RouteDrawer({
    @required this.icon,
    @required this.routeName,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(routeName);
          },
        ),
        Divider(),
      ],
    );
  }
}
