import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';

const KTextStyle = TextStyle(color: Colors.white, fontSize: 18);

class CartTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final item = Provider.of<CartItem>(context);
    final cart = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(item.id),
      background: Container(
        color: Colors.redAccent,
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        padding: const EdgeInsets.all(10),
        child: Icon(
          Icons.delete,
          size: 40,
        ),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        cart.deleteItem(item.id);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                content: Text('Remove this Item ?'),
                title: Text('Are you sure ?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: Text('NO'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text('YES'),
                  ),
                ],
              );
            });
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        child: ListTile(
          tileColor: Colors.purpleAccent,
          leading: Column(children: [
            Text('price'),
            Text('\$${item.price}', style: KTextStyle)
          ]),
          title: Text(
            '${item.title}',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic),
          ),
          trailing: Column(
            children: [
              Text('total'),
              Text(
                '\$${(item.price * item.quntity).toStringAsFixed(2)}',
                style: KTextStyle,
              ),
            ],
          ),
          subtitle: Row(
            children: [
              IconButton(
                onPressed: () {
                  item.quntityDec();
                  cart.notifyListeners();
                },
                icon: Icon(Icons.remove_circle),
              ),
              Expanded(
                child: Container(
                    color: Colors.white54,
                    child: Text(
                      'X ${item.quntity}',
                      textAlign: TextAlign.center,
                    )),
              ),
              IconButton(
                onPressed: () {
                  item.quntityInc();
                  cart.notifyListeners();
                },
                icon: Icon(Icons.add_circle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
