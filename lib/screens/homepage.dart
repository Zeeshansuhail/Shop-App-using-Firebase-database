import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';
import '../screens/cart_screen.dart';
import '../widget/drawer.dart';
import '../provider/cart.dart';
import '../widget/badge.dart';
import '../widget/product_grid.dart';
import '../provider/product_data.dart';

enum Selectfilter {
  Like,
  All,
}

class Homepages extends StatefulWidget {
  static const routenamed = "homepage_screen";
  @override
  _HomepagesState createState() => _HomepagesState();
}

class _HomepagesState extends State<Homepages> {
  bool IsLike = false;

  final List<ProductModel> product = [];
  bool _initstate = true;
  var _isloading = false;

  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isloading = true;
      });
      await Provider.of<Products>(context, listen: false).fetchandproduct();
      setState(() {
        _isloading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Shop App"),
          actions: [
            PopupMenuButton(
                onSelected: (Selectfilter selectfilter) {
                  setState(() {
                    if (selectfilter == Selectfilter.Like)
                      IsLike = true;
                    else
                      IsLike = false;
                  });
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        child: Text("Our Faourite"),
                        value: Selectfilter.Like,
                      ),
                      PopupMenuItem(
                        child: Text("Show all"),
                        value: Selectfilter.All,
                      ),
                    ]),
            Consumer<Cart>(
              builder: (_, cart, ch) =>
                  Badge(child: ch, value: cart.Itemcount.toString()),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeNamed);
                },
              ),
            )
          ],
        ),
        drawer: DrawerApp(),
        body: _isloading
            ? Center(child: CircularProgressIndicator())
            : Productgrid(IsLike));
  }
}
