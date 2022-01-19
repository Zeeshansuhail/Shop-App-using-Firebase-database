import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_data.dart';
import '../provider/products.dart';
import '../widget/product_item.dart';

class Productgrid extends StatelessWidget {
  bool likeonly;
  Productgrid(this.likeonly);
  @override
  Widget build(BuildContext context) {
    final productdata = Provider.of<Products>(context);
    final product = likeonly ? productdata.like : productdata.item;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: product.length,
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
        value: product[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0),
    );
  }
}
