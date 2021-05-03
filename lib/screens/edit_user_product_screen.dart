import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';

import '../provider/products_provider.dart';

class EditUserProductScreen extends StatefulWidget {
  static const routeName = '/edit-user-product';

  @override
  _EditUserProductScreenState createState() => _EditUserProductScreenState();
}

class _EditUserProductScreenState extends State<EditUserProductScreen> {
  final _form = GlobalKey<FormState>();
  final _imageController = TextEditingController();

  bool _isEditing = false;
  Product product;
  bool _isInit = true;
  bool _isLoading = false;

  Future<void> _okButton() async {
    if (!_form.currentState.validate()) {
      return Future.value();
    }
    _form.currentState.save();

    if (_isEditing) {
      await Provider.of<Products>(context, listen: false).editProduct(
        product.id,
        product,
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Products>(context, listen: false).addProduct(product);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error happened !'),
            content: Text('something went wrong !!'),
            actions: [
              TextButton(
                child: Text('Okey'),
                onPressed: () => Navigator.of(ctx).pop(),
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  void _cancelButton() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> pageMode =
        ModalRoute.of(context).settings.arguments;
    final products = Provider.of<Products>(context, listen: false);

    if (_isInit) {
      _isEditing = (pageMode['mode'] == 'Edit');
      product = _isEditing
          ? products.findById(pageMode['id'])
          : Product(
              id: null, title: '', description: '', imageUrl: '', price: 0);
      _imageController.text = product.imageUrl;
      _isInit = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editing that Product' : 'Adding new Product'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Title'),
                        initialValue: product.title,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          product.title = value;
                        },
                        validator: (value) {
                          return value.isEmpty
                              ? 'please provide a title'
                              : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        initialValue: product.price.toString(),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          product.price = double.parse(value);
                        },
                        validator: (value) {
                          if (value.isEmpty) return 'please provide a price';
                          if (double.tryParse(value) == null)
                            return 'please provide a valid price ex(12.34)';

                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'description'),
                        initialValue: product.description,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) {
                          product.description = value;
                        },
                        validator: (value) {
                          return value.isEmpty
                              ? 'please provide a description'
                              : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                            height: 100,
                            width: 100,
                            child: FittedBox(
                              child: _imageController.text.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('enter Image Url'))
                                  : Image(
                                      image:
                                          NetworkImage(_imageController.text),
                                      fit: BoxFit.cover),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                controller: _imageController,
                                decoration:
                                    InputDecoration(labelText: 'ImageUrl'),
                                keyboardType: TextInputType.url,
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'please provide an Image Url'
                                      : null;
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                onSaved: (value) => product.imageUrl = value,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child:
                          TextButton(onPressed: _okButton, child: Text('Save')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextButton(
                        child: Text(
                          'Cancel',
                        ),
                        onPressed: _cancelButton,
                      ),
                    ),
                  ],
                ),
              )),
    );
  }
}
