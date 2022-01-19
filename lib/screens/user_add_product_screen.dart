import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../provider/products.dart';
import '../widget/user_product_item.dart';
import '../widget/drawer.dart';

class UserAddProductScreen extends StatelessWidget {
  static const routeNamed = 'User_add_product';

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchandproduct(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productdata = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("User Product"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeNamed);
              })
        ],
      ),
      drawer: DrawerApp(),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refresh(context),
                    child: Consumer<Products>(
                      builder: (context, productdata, _) => ListView.builder(
                          itemCount: productdata.item.length,
                          itemBuilder: (_, i) {
                            return UserItem(
                              productname: productdata.item[i].title,
                              imageurl: productdata.item[i].imageUrl,
                              productid: productdata.item[i].id,
                            );
                          }),
                    ),
                  ),
      ),
    );
  }
}
