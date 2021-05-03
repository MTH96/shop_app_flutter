import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_user_product_screen.dart';

import '../provider/products_provider.dart';

import '../widgets/main_drawer.dart';
import '../widgets/product_user_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Products'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(
              EditUserProductScreen.routeName,
              arguments: {'mode': 'Add'} as Map<String, String>,
            ),
            icon: Icon(
              Icons.add,
            ),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<Products>(context, listen: false)
              .getServerProducts();
        },
        child: ListView.builder(
          itemCount: products.items.length,
          itemBuilder: (context, index) => ChangeNotifierProvider.value(
            value: products.items[index],
            child: ProductUserItem(),
          ),
        ),
      ),
    );
  }
}
