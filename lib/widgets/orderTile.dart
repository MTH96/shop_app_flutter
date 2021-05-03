import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../provider/order.dart';

class OrderTile extends StatefulWidget {
  final OrderItem order;
  OrderTile(this.order);

  @override
  _OrderTileState createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          child: ListTile(
            title: Text('\$${widget.order.price}'),
            subtitle: Text(
              '${DateFormat('dd / mm / yyyy  hh:mm').format(widget.order.time)}',
            ),
            trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });

              print(_expanded);
            },
          ),
        ),
        if (_expanded)
          Container(
            height: min(widget.order.products.length * 30.0 + 50, 180.0),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListView(
              children: widget.order.products
                  .map((prod) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${prod.title}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                children: [
                                  Text('${prod.quntity}X'),
                                  Text(
                                    '\$${prod.price}',
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              )
                            ],
                          ),
                          Divider()
                        ],
                      ))
                  .toList(),
            ),
          )
      ],
    );
  }
}
