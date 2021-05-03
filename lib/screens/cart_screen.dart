import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/order.dart';
import '../provider/cart.dart';
import '../widgets/cartTile.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Text('total',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                Spacer(flex: 3),
                Chip(
                  padding: const EdgeInsets.all(5),
                  label: Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Spacer(),
                OrderButton(cart)
              ],
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (_, index) => ChangeNotifierProvider.value(
                      value: cart.items.values.toList()[index],
                      child: CartTile())),
            )
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;
  OrderButton(this.cart);
  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context, listen: false);

    final scaffold = ScaffoldMessenger.of(context);

    return TextButton(
      onPressed: widget.cart.items.isEmpty
          ? null
          : () async {
              if (!_isLoading) {
                setState(() {
                  _isLoading = true;
                });
                try {
                  await order.addOrder(widget.cart.items.values.toList(),
                      widget.cart.totalAmount);
                  widget.cart.clear();
                } catch (error) {
                  scaffold.hideCurrentSnackBar();
                  scaffold
                      .showSnackBar(SnackBar(content: Text(error.toString())));
                }
                setState(() {
                  _isLoading = false;
                });
              }
            },
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Text(
              'ORDER NOW',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
    );
  }
}
