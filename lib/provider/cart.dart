import 'package:flutter/material.dart';

class CartItem with ChangeNotifier {
  String id;
  String title;
  double price;
  int quntity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quntity,
  });
  void quntityInc() {
    quntity++;
    notifyListeners();
  }

  void quntityDec() {
    if (quntity > 0) {
      quntity--;
      notifyListeners();
    }
  }
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {}; //{productId:CartItem,...}

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double amount = 0;
    _items.forEach((key, cartItem) {
      amount += cartItem.price * cartItem.quntity;
    });
    return amount;
  }

  void deleteItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void addCartItem({
    @required String productId,
    @required String title,
    @required double price,
  }) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (exitstedCartItem) => CartItem(
                id: exitstedCartItem.id,
                price: exitstedCartItem.price,
                quntity: exitstedCartItem.quntity + 1,
                title: exitstedCartItem.title,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: productId,
                title: title,
                price: price,
                quntity: 1,
              ));
    }
    notifyListeners();
  }

  void removeSingleProduct(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId].quntity > 1)
      _items.update(
          productId,
          (exitstedCartItem) => CartItem(
                id: exitstedCartItem.id,
                price: exitstedCartItem.price,
                quntity: exitstedCartItem.quntity - 1,
                title: exitstedCartItem.title,
              ));
    else
      _items.remove(productId);

    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
