import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import '../screens/order_screen.dart';
import '../screens/user_add_product_screen.dart';

class DrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Welcome to the User"),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrderScreen.routeNamed);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Product"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserAddProductScreen.routeNamed);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();
               Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Authication>(context, listen: false).Logout();
            },
          ),
        ],
      ),
    );
  }
}
