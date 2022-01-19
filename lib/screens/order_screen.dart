import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/drawer.dart';
import '../provider/order.dart' show Order;
import '../widget/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeNamed = "Orders_detail_Screen";

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _loading = true;
      });
      await Provider.of<Order>(context, listen: false).fetchtheorderdata();
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderdata = Provider.of<Order>(context).order;
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      drawer: DrawerApp(),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : (orderdata.length == 0)
              ? Center(
                  child: Text("No orders"),
                )
              : ListView.builder(
                  itemCount: orderdata.length,
                  itemBuilder: (context, i) => OrderItem(orderdata[i])),
    );
  }
}
