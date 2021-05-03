import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';

class ProductScreen extends StatelessWidget {
  static const routeName = '/product';
  @override
  Widget build(BuildContext context) {
    final String productId = ModalRoute.of(context).settings.arguments;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.fitWidth,
              ),
              Positioned(
                  bottom: 10,
                  right: 20,
                  child: Text(
                    loadedProduct.title,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).accentColor,
                    ),
                  ))
            ],
          ),
          Text(
            loadedProduct.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            '\$${loadedProduct.price}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }
}
