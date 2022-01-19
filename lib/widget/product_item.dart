import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import '../provider/cart.dart';
import '../provider/product_data.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductModel>(context);
    final cart = Provider.of<Cart>(context);
    final auth = Provider.of<Authication>(context);
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDeatilScreen.routeNamed,
                  arguments: product.id);
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              color: Theme.of(context).accentColor,
              icon: product.isfavorite == true
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
              onPressed: () {
                product.toggleSwitch(auth.token, auth.userid);
              },
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.additem(product.id, product.title, product.price);
                Scaffold.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Added to the Cart!"),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.singleproduct(product.id);
                      },
                    ),
                  ),
                );
              },
            ),
          )),
    );
  }
}
