import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import '../provider/cart.dart';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String productid;
  final double amount;
  final List<CartItem> productitem;
  final DateTime date;

  OrderItem({
    @required this.productid,
    @required this.amount,
    @required this.productitem,
    @required this.date,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  String authtoken;
  String userId;

  Order(this.authtoken, this.userId, this._orders);

  List<OrderItem> get order {
    return [..._orders];
  }

  Future<void> fetchtheorderdata() async {
    final url = Uri.parse(
        'https://test-1-88189-default-rtdb.asia-southeast1.firebasedatabase.app/Orders/$userId.json?auth=$authtoken');

    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final List<OrderItem> _loadedordersitem = [];
      final extractedorderdata =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedorderdata == null) {
        return;
      }
      extractedorderdata.forEach((id, orderdata) {
        _loadedordersitem.add(OrderItem(
          productid: id,
          amount: orderdata['amount'],
          date: DateTime.parse(orderdata['date']),
          productitem: (orderdata['productitem'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: id,
                  //title: item['title'],
                  price: item['price'],
                  quantity: item['quantity'], title: item['title'],
                ),
              )
              .toList(),
        ));
      });
      _orders = _loadedordersitem.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  int get itemcount {
    return _orders.length;
  }

  Future<void> addorder(List<CartItem> cartitem, double total) async {
    final url = Uri.parse(
        'https://test-1-88189-default-rtdb.asia-southeast1.firebasedatabase.app/Orders/$userId.json?auth=$authtoken');

    final responce = await http.post(url,
        body: json.encode({
          'amount': total,
          'date': DateTime.now().toString(),
          'productitem': cartitem
              .map((cartproditem) => {
                    'id': cartproditem.id,
                    'title': cartproditem.title,
                    'price': cartproditem.price,
                    'quantity': cartproditem.quantity,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
            productid: json.decode(responce.body)['name'],
            amount: total,
            productitem: cartitem,
            date: DateTime.now()));

    notifyListeners();
  }
}
