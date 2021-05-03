import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_screen.dart';
import '../provider/product.dart';
import '../provider/products_provider.dart';
import '../provider/cart.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    final scaffold = ScaffoldMessenger.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey)),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              ProductScreen.routeName,
              arguments: product.id,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              onPressed: () async {
                try {
                  await product.toggleFavoriteState();
                } catch (error) {
                  scaffold.hideCurrentSnackBar();
                  scaffold
                      .showSnackBar(SnackBar(content: Text(error.toString())));
                }
              },
              icon: Icon(
                product.isFavorites ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          title: Text(product.title),
          trailing: IconButton(
            icon: Icon(
              Icons.add_shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              cart.addCartItem(
                productId: product.id,
                title: product.title,
                price: product.price,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('item added to the Cart'),
                elevation: 10,
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleProduct(product.id);
                  },
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
