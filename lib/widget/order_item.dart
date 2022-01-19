import 'package:flutter/material.dart';
import 'dart:math';
import '../provider/order.dart' as Or;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final Or.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expand = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date)),
            trailing: IconButton(
              icon: _expand ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expand = !_expand;
                });
              },
            ),
          ),
          if (_expand)
            Container(
                padding: EdgeInsets.all(10.0),
                height:
                    min(widget.order.productitem.length * 20.0 + 100.0, 180.0),
                child: ListView(
                  children: widget.order.productitem
                      .map(
                        (prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.title,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${prod.quantity} x \$${prod.price}',
                              style:
                                  TextStyle(fontSize: 18.0, color: Colors.grey),
                            )
                          ],
                        ),
                      )
                      .toList(),
                ))
        ],
      ),
    );
  }
}
