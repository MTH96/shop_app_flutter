import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_user_product_screen.dart';
import '../provider/products_provider.dart';
import '../provider/product.dart';

class ProductUserItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final product = Provider.of<Product>(context, listen: false);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => Navigator.of(context).pushNamed(
                EditUserProductScreen.routeName,
                arguments:
                    {'mode': 'Edit', 'id': product.id} as Map<String, String>,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(product.id);
                } catch (error) {
                  scaffold.hideCurrentSnackBar();
                  scaffold.showSnackBar(
                      SnackBar(content: Text('Deleting Failed!')));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
