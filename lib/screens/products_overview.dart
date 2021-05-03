import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/gridView_builder.dart';
import '../provider/cart.dart';
import '../provider/products_provider.dart';
import './cart_screen.dart';

enum FilterOption { OnlyFavorite, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool showFavOnly = false;
  bool _isLoading = true;

  void _initProductsList() async {
    await Provider.of<Products>(context, listen: false).getServerProducts();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _initProductsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOption value) {
              setState(() {
                if (value == FilterOption.All)
                  showFavOnly = false;
                else
                  showFavOnly = true;
              });
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: const Text('Only Favorite'),
                value: FilterOption.OnlyFavorite,
              ),
              PopupMenuItem(
                child: const Text('Show All'),
                value: FilterOption.All,
              )
            ],
          ),
          Consumer<Cart>(
              builder: (context, cart, child) {
                return Badge(child: child, value: cart.itemsCount.toString());
              },
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              )),
        ],
      ),
      drawer: MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<Products>(context, listen: false)
              .getServerProducts();
        },
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : GridViewBuilder(showFavOnly),
      ),
    );
  }
}
