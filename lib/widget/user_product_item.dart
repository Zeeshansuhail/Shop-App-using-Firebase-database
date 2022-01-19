import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/user_add_product_screen.dart';

class UserItem extends StatelessWidget {
  String productid;
  String productname;
  String imageurl;

  UserItem({this.productname, this.imageurl, this.productid});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(productname),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          imageurl,
        ),
      ),
      trailing: Container(
        width: 100.0,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeNamed,
                    arguments: productid);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .removesingleproduct(productid);
                } catch (error) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Deleting Failed!"),
                    ),
                  );
                }
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
