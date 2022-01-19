import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/httpexception.dart';

class Authication with ChangeNotifier {
  String _token;
  DateTime _expiredatetime;
  String _Userid;
  Timer _authTimer;

  bool get isAuth {
    if (token != null) {
      return true;
    }
    return false;
  }

  String get token {
    if (_expiredatetime != null &&
        _expiredatetime.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userid {
    return _Userid;
  }

  Future<void> _urlsegments(
      String email, String password, String urlsegments) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlsegments?key=AIzaSyBTF9J-O74Umodi96pwKleqmlA-dUh6cts");

    try {
      final responce = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responsedata = json.decode(responce.body);
      if (responsedata['error'] != null) {
        throw Http(responsedata['error']['message']);
      }
      _token = responsedata['idToken'];
      _Userid = responsedata['localId'];
      _expiredatetime = DateTime.now()
          .add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      autoLogout();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final logData = json.encode({
        "token": _token,
        "userId": _Userid,
        "experyDate": _expiredatetime.toIso8601String(),
      });
      pref.setString("logData", logData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> Login(String email, String password) async {
    return _urlsegments(email, password, "signInWithPassword");
  }

  Future<void> signup(String email, String password) async {
    return _urlsegments(email, password, "signUp");
  }

  Future<void> Logout() async {
    _token = null;
    _Userid = null;
    _expiredatetime = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    // final pref = await SharedPreferences.getInstance();
    // pref.clear();
  }

  Future<bool> autologin() async {
    final pref = await SharedPreferences.getInstance();

    if (!pref.containsKey("logData")) {
      return false;
    }
    final extracteddata =
        json.decode(pref.getString("logData")) as Map<String, Object>;
    final exptiredata = DateTime.parse(extracteddata['experyDate']);
    if (exptiredata.isBefore(DateTime.now())) {
      return false;
    }
    _token = extracteddata['token'];
    _Userid = extracteddata['uesrId'];
    _expiredatetime = exptiredata;
    notifyListeners();
    autoLogout();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final _expiretime = _expiredatetime.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: _expiretime), Logout);
  }
}
