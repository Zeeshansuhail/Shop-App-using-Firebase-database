import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';

class CartData extends StatelessWidget {
  final String cartid;
  final String productid;
  final String title;
  final double price;
  final int quantity;

  CartData(
      {@required this.cartid,
      @required this.productid,
      @required this.title,
      @required this.price,
      @required this.quantity});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(cartid),
      background: Container(
        padding: EdgeInsets.only(right: 20.0),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).dismiss(productid);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: FittedBox(
                    child: Text(
                      '\$$price',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              title: Text(
                '$title',
                style: TextStyle(fontSize: 20.0),
              ),
              subtitle: Text('Total \$${price * quantity}'),
              trailing: Text('$quantity x'),
            )),
      ),
    );
  }
}
