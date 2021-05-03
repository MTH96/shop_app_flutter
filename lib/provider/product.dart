import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Product with ChangeNotifier {
  String id;
  String description;
  String title;
  double price;
  String imageUrl;
  bool isFavorites;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorites = false,
  });

  void editProduct(Product newProduct) {
    this.title = newProduct.title;
    this.description = newProduct.description;
    this.price = newProduct.price;
    this.imageUrl = newProduct.imageUrl;
  }

  Future<void> toggleFavoriteState() async {
    final url = Uri.parse(
        'https://shop-app-aea0a-default-rtdb.firebaseio.com/products/$id.json');

    bool changedFav = isFavorites;
    isFavorites = !isFavorites;
    notifyListeners();
    try {
      final response =
          await http.patch(url, body: json.encode({'isFavorite': !changedFav}));
      if (response.statusCode >= 400)
        throw (HttpException('couldn\'tchange check your interner connection'));
      else
        changedFav = null;
    } catch (e) {
      isFavorites = changedFav;
      notifyListeners();
      throw (e);
    }
  }
}
