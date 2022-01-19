import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class ProductDeatilScreen extends StatelessWidget {
  static const routeNamed = "product_detail_screen";

  @override
  Widget build(BuildContext context) {
    final productid = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context).findid(productid);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300.0,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              '\$${product.price}}',
              style: TextStyle(color: Colors.grey, fontSize: 20.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              product.description,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
