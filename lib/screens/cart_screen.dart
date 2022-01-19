import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order.dart';
import '../widget/cart_data.dart';
import '../provider/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeNamed = "Cart_Screen";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",
                      style: TextStyle(
                        fontSize: 20.0,
                      )),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalprice.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Flatbutton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.Item.length,
                  itemBuilder: (ctx, i) => CartData(
                      cartid: cart.Item.values.toList()[i].id,
                      productid: cart.Item.keys.toList()[i],
                      title: cart.Item.values.toList()[i].title,
                      price: cart.Item.values.toList()[i].price,
                      quantity: cart.Item.values.toList()[i].quantity)))
        ],
      ),
    );
  }
}

class Flatbutton extends StatefulWidget {
  const Flatbutton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _FlatbuttonState createState() => _FlatbuttonState();
}

class _FlatbuttonState extends State<Flatbutton> {
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalprice <= 0)
          ? null
          : () async {
              setState(() {
                _isloading = true;
              });
              await Provider.of<Order>(context, listen: false).addorder(
                  widget.cart.Item.values.toList(), widget.cart.totalprice);
              widget.cart.clear();
              setState(() {
                _isloading = false;
              });
            },
      child: _isloading ? CircularProgressIndicator() : Text("ORDER NOW"),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
