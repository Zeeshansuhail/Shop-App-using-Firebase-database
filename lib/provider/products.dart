import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/httpexception.dart';
import 'product_data.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<ProductModel> _item = [
    // ProductModel(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // ProductModel(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // ProductModel(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // ProductModel(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  String authtoken;
  String userid;
  Products(this.authtoken, this.userid, this._item);

  List<ProductModel> get like {
    return _item.where((prodlike) => prodlike.isfavorite).toList();
  }

  List<ProductModel> get item {
    return [..._item];
  }

  ProductModel findid(String id) {
    return _item.firstWhere((prod) => prod.id == id);
  }

  void addproduct() {
    notifyListeners();
  }

  Future<void> removesingleproduct(String prodid) async {
    final url = Uri.parse(
        'https://test-1-88189-default-rtdb.asia-southeast1.firebasedatabase.app/products/$prodid.json?auth=$authtoken');
    final exstingproducdindex = _item.indexWhere((prod) => prodid == prod.id);
    var exstingproducts = _item[exstingproducdindex];
    final responce = await http.delete(url);
    _item.removeAt(exstingproducdindex);
    notifyListeners();
    if (responce.statusCode >= 400) {
      _item.insert(exstingproducdindex, exstingproducts);
      notifyListeners();
      throw Http("Could not delete products");
    }
    exstingproducts = null;
  }

  Future<void> fetchandproduct([bool filterbyuser = false]) async {
    final showAll = filterbyuser ? 'orderBy="createrId"&equalTo="$userid"' : '';
    var url = Uri.parse(
        'https://test-1-88189-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authtoken&$showAll');

    try {
      final response = await http.get(url);

      final Extracteddata = json.decode(response.body) as Map<String, dynamic>;
      if (Extracteddata == null) {
        return;
      }
      url = Uri.parse(
          'https://test-1-88189-default-rtdb.asia-southeast1.firebasedatabase.app/userfavourites/$userid.json?auth=$authtoken');

      final favresponse = await http.get(url);
      final extractedfav = json.decode(favresponse.body);
      final List<ProductModel> _loadedproducts = [];
      Extracteddata.forEach((prodid, proddata) {
        _loadedproducts.add((ProductModel(
          id: prodid,
          title: proddata['title'],
          description: proddata['description'],
          price: proddata['price'],
          isfavorite:
              extractedfav == null ? false : extractedfav[prodid] ?? false,
          imageUrl: proddata['imageurl'],
        )));
      });
      _item = _loadedproducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> newproducts(ProductModel prod) async {
    final url = Uri.parse(
        'https://test-1-88189-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authtoken');

    try {
      final value = await http.post(
        url,
        body: json.encode({
          'createrId': userid,
          'title': prod.title,
          'description': prod.description,
          'price': prod.price,
          'imageurl': prod.imageUrl,
        }),
      );
      final newprod = ProductModel(
          id: json.decode(value.body)['name'],
          title: prod.title,
          description: prod.description,
          price: prod.price,
          imageUrl: prod.imageUrl);
      //_item.add(newprod);
      _item.insert(0, newprod);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateproduct(String id, ProductModel newprod) async {
    final Productindex = _item.indexWhere((prod) => prod.id == newprod.id);
    if (Productindex >= 0) {
      final url = Uri.parse(
          'https://test-1-88189-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authtoken');

      await http.patch(url,
          body: json.encode({
            'title': newprod.title,
            'imageurl': newprod.imageUrl,
            'description': newprod.description,
            'price': newprod.price,
          }));

      _item[Productindex] = newprod;
      notifyListeners();
    }
  }
}
