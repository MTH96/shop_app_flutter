import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/order.dart';
import '../widgets/orderTile.dart';
import '../widgets/main_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = './order';
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    final scaffold = ScaffoldMessenger.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: MainDrawer(),
        body: RefreshIndicator(
            child: OrdersUpdate(ordersData: ordersData),
            onRefresh: () async {
              try {
                await ordersData.getOrders();
              } catch (error) {
                scaffold.hideCurrentSnackBar();

                scaffold
                    .showSnackBar(SnackBar(content: Text(error.toString())));
              }
            }));
  }
}

class OrdersUpdate extends StatefulWidget {
  const OrdersUpdate({@required this.ordersData});

  final Orders ordersData;

  @override
  _OrdersUpdateState createState() => _OrdersUpdateState();
}

class _OrdersUpdateState extends State<OrdersUpdate> {
  Future _orders;

  Future _getOrders() {
    return Provider.of<Orders>(context, listen: false).getOrders();
  }

  @override
  void initState() {
    _orders = _getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _orders,
        builder: (ctx, futureReturn) {
          if (futureReturn.connectionState == ConnectionState.waiting)
            //still wating
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            //done
            if (futureReturn.error != null) {
              //done with error
              return Center(
                child: Text('An error occure'),
              );
            }
            //done without error
            return ListView.builder(
              itemCount: widget.ordersData.orders.length,
              itemBuilder: (_, index) =>
                  OrderTile(widget.ordersData.orders[index]),
            );
          }
        });
  }
}
