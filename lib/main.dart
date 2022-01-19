import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/splash_screen.dart';
import './provider/auth.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_add_product_screen.dart';
import './provider/order.dart';
import './screens/cart_screen.dart';
import './screens/order_screen.dart';
import './provider/cart.dart';
import './provider/products.dart';
import './screens/homepage.dart';
import './screens/product_detail_screen.dart';

void main() {
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Authication(),
          ),
          ChangeNotifierProxyProvider<Authication, Products>(
            update: (context, auth, previousproducts) => Products(
                auth.token,
                auth.userid,
                previousproducts == null ? [] : previousproducts.item),
          ),
          ChangeNotifierProvider(create: (context) => Cart()),
          ChangeNotifierProxyProvider<Authication, Order>(
              update: (context, auth, previousorder) => Order(
                  auth.token,
                  auth.userid,
                  previousorder == null ? [] : previousorder.order))
        ],
        child: Consumer<Authication>(
          builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Shop App",
            theme: ThemeData(
                primarySwatch: Colors.purple, accentColor: Colors.deepOrange),
            home: auth.isAuth
                ? Homepages()
                : FutureBuilder(
                    future: auth.autologin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              Homepages.routenamed: (ctx) => Homepages(),
              ProductDeatilScreen.routeNamed: (ctx) => ProductDeatilScreen(),
              CartScreen.routeNamed: (ctx) => CartScreen(),
              OrderScreen.routeNamed: (ctx) => OrderScreen(),
              UserAddProductScreen.routeNamed: (ctx) => UserAddProductScreen(),
              EditProductScreen.routeNamed: (ctx) => EditProductScreen(),
              AuthScreen.routeNamed: (ctx) => AuthScreen(),
            },
          ),
        ));
  }
}
