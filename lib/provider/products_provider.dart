import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavorites).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> editProduct(String productId, Product newProduct) async {
    final url = Uri.parse(
        'https://shop-app-aea0a-default-rtdb.firebaseio.com/products/$productId.json');
    try {
      http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'description': newProduct.description,
          }));
      _items
          .firstWhere((element) => element.id == productId)
          .editProduct(newProduct);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future getServerProducts() async {
    final url = Uri.parse(
        'https://shop-app-aea0a-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.get(url);
      final productsData = json.decode(response.body) as Map<String, dynamic>;
      if (productsData == null) return;
      final List<Product> products = [];
      productsData.forEach((productId, productData) {
        products.add(
          Product(
              id: productId,
              title: productData['title'],
              description: productData['description'],
              imageUrl: productData['imageUrl'],
              price: productData['price'],
              isFavorites: productData['isFavorite']),
        );
        _items = products;
        notifyListeners();
      });
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future addProduct(Product product) async {
    final url = Uri.parse(
        'https://shop-app-aea0a-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'description': product.description,
            'isFavorite': product.isFavorites
          }));

      product.id = json.decode(response.body)['name'];

      _items.add(product);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> deleteProduct(productId) async {
    final url = Uri.parse(
        'https://shop-app-aea0a-default-rtdb.firebaseio.com/products/$productId.json');
//find the item
    final productIndex =
        _items.indexWhere((element) => element.id == productId);
    var deletedProduct = _items[productIndex];
//remove it locally
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
    //try to remove it from the server
    try {
      final response = await http.delete(url);

      if (response.statusCode >= 400)
        throw (HttpException(
            'couldn\'t delete it')); //httpError(response.statusCode));
      else
        deletedProduct = null; //deleted backup copy
    } catch (error) {
      //if there is an error undo deleting
      _items.insert(productIndex, deletedProduct);
      notifyListeners();
      print('=============>$error');
      throw (error);
    }
  }
}
