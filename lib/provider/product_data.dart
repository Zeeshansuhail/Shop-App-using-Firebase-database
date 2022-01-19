import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProductModel with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isfavorite;

  ProductModel({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isfavorite = false,
  });

  void setfav(bool newval) {
    isfavorite = newval;
    notifyListeners();
  }

  Future<void> toggleSwitch(String authtoken, String ueserid) async {
    final oldfavourite = isfavorite;
    isfavorite = !isfavorite;
    notifyListeners();

    final url = Uri.parse(
        'https://test-1-88189-default-rtdb.asia-southeast1.firebasedatabase.app/userfavourites/$ueserid/$id.json?auth=$authtoken');
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isfavorite,
        ),
      );
      // print(response.statusCode);
      if (response.statusCode >= 400) {
        setfav(oldfavourite);
      }
    } catch (error) {
      setfav(oldfavourite);
    }
  }
}
