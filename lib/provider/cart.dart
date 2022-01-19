import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _item = {};

  Map<String, CartItem> get Item {
    return {..._item};
  }

  int get Itemcount {
    return _item.length;
  }

  double get totalprice {
    var total = 0.0;
    _item.forEach((key, CartItem) {
      total += CartItem.price * CartItem.quantity;
    });
    return total;
  }

  void additem(String productid, String title, double price) {
    if (_item.containsKey(productid)) {
      _item.update(
          productid,
          (existingcartitem) => CartItem(
              id: existingcartitem.id,
              title: existingcartitem.title,
              price: existingcartitem.price,
              quantity: existingcartitem.quantity + 1));
    } else {
      _item.putIfAbsent(
          productid,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void singleproduct(String productid) {
    if (!_item.containsKey(productid)) return;
    if (_item[productid].quantity > 1) {
      _item.update(
          productid,
          (existingcartproduct) => CartItem(
              id: existingcartproduct.id,
              title: existingcartproduct.title,
              price: existingcartproduct.price,
              quantity: existingcartproduct.quantity - 1));
    } else {
      _item.remove(productid);
    }
    notifyListeners();
  }

  void dismiss(String productid) {
    _item.remove(productid);
    notifyListeners();
  }

  void clear() {
    _item = {};
    notifyListeners();
  }
}
