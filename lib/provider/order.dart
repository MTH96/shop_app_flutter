import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double price;
  final DateTime time;
  final List<CartItem> products;

  OrderItem({
    @required this.id,
    @required this.products,
    @required this.price,
    @required this.time,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> items, double total) async {
    final url = Uri.parse(
        'https://shop-app-aea0a-default-rtdb.firebaseio.com/orders.json');
    final time = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'products': [
              ...items.map((e) {
                return {
                  'id': e.id,
                  'title': e.title,
                  'price': e.price,
                  'quntity': e.quntity,
                };
              }).toList()
            ],
            'price': total,
            'time': time.toIso8601String(),
          }));

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          products: items,
          price: total,
          time: time,
        ),
      );
      notifyListeners();

      if (response.statusCode >= 400)
        throw (HttpException(
            'could\'t set the order check your internet connection'));
    } catch (error) {
      _orders.removeAt(0);
      notifyListeners();
      throw (error);
    }
  }

  Future<void> getOrders() async {
    final url = Uri.parse(
        'https://shop-app-aea0a-default-rtdb.firebaseio.com/orders.json');

    try {
      final response = await http.get(url);
      if (response.statusCode >= 400)
        throw (HttpException(
            'could\'t set the order check your internet connection'));
      else {
        var orders = json.decode(response.body) as Map<String, dynamic>;

        _orders = [];
        if (orders == null) return;
        orders.forEach((orderId, orderData) {
          _orders.insert(
              0,
              OrderItem(
                id: orderId,
                price: orderData['price'],
                time: DateTime.parse(orderData['time']),
                products:
                    (orderData['products'] as List<dynamic>).map((product) {
                  return CartItem(
                      id: product['id'],
                      title: product['title'],
                      price: product['price'],
                      quntity: product['quntity']);
                }).toList(),
              ));
        });

        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
