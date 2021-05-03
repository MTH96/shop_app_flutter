import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../provider/products_provider.dart';
import 'product_grid_item.dart';

class GridViewBuilder extends StatelessWidget {
  final bool showFavOnly;

  GridViewBuilder(this.showFavOnly);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavOnly ? productsData.favItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductGridItem(),
      ),
      itemCount: products.length,
    );
  }
}
