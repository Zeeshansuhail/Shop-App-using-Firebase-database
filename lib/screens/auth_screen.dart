import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/screens/homepage.dart';
import '../provider/auth.dart';
import '../models/httpexception.dart';

enum authmode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeNamed = "Auth_Screen";

  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;
    final transalateconfig = Matrix4.rotationZ(-8 * pi / 180);
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                    Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                  stops: [0, 1])),
        ),
        SingleChildScrollView(
          child: Container(
            height: devicesize.height,
            width: devicesize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(-10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.deepOrange.shade900,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      'MyShop',
                      style: TextStyle(
                        color: Theme.of(context).accentTextTheme.title.color,
                        fontSize: 50,
                        fontFamily: 'Anton',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: devicesize.width > 600 ? 2 : 3,
                  child: Authcard(),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Authcard extends StatefulWidget {
  const Authcard({
    Key key,
  }) : super(key: key);

  @override
  _AuthcardState createState() => _AuthcardState();
}

class _AuthcardState extends State<Authcard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formkey = GlobalKey();
  Map<String, String> authdata = {'email': '', 'password': ''};
  authmode _authMode = authmode.Login;
  final _passwordcontroller = TextEditingController();
  AnimationController _animationController;
  Animation<double> _opacityanimation;
  Animation<Offset> _slidetransition;

  @override
  void initState() {
    // TODO: implement initState
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _opacityanimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _slidetransition = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  var _Isloading = false;
  void _showdialog(String Message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Autication is failed"),
              content: Text(Message),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK")),
              ],
            ));
  }

  Future<void> _saveform() async {
    if (!_formkey.currentState.validate()) return;

    _formkey.currentState.save();
    setState(() {
      _Isloading = true;
    });
    try {
      if (_authMode == authmode.Login) {
        await Provider.of<Authication>(context, listen: false)
            .Login(authdata['email'], authdata['password']);
      } else {
        await Provider.of<Authication>(context, listen: false)
            .signup(authdata['email'], authdata['password']);
      }
      // Navigator.of(context).pushReplacementNamed(Homepages.routenamed);
    } on Http catch (error) {
      var message = "Autication have some issues";
      if (error.toString().contains("EMAIL_EXISTS")) {
        message = "This email address already in use";
      } else if (error.toString().contains("TOO_MANY_ATTEMPTS_TRY_LATER")) {
        message =
            "We have blocked all requests from this device due to unusual activity. Try again later.";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        message = "This email is not format";
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        message = "This password is not strong";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        message = "This password is curret";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        message = "This email address is not found";
      }
      _showdialog(message);
    } catch (error) {
      const message = "autication is failed";
      _showdialog(message);
    }

    setState(() {
      _Isloading = false;
    });
  }

  void _switchmode() {
    if (_authMode == authmode.Login) {
      setState(() {
        _authMode = authmode.Signup;
        _animationController.forward();
      });
    } else
      setState(() {
        _authMode = authmode.Login;
        _animationController.reverse();
      });
  }

  @override
  Widget build(BuildContext context) {
    final deviceseize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 300),
        height: _authMode == authmode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == authmode.Signup ? 320 : 260),
        width: deviceseize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "E-Mail"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return "Email is not correct";
                      }

                      return null;
                    },
                    onSaved: (newValue) {
                      authdata['email'] = newValue;
                    },
                  ),
                  TextFormField(
                    controller: _passwordcontroller,
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return "Password is too shot or empty";
                      }

                      return null;
                    },
                    onSaved: (newValue) {
                      authdata['password'] = newValue;
                    },
                  ),
                  // if (_authMode == authmode.Signup)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    constraints: BoxConstraints(
                        minHeight: _authMode == authmode.Signup ? 60 : 0,
                        maxHeight: _authMode == authmode.Signup ? 120 : 0),
                    child: FadeTransition(
                      opacity: _opacityanimation,
                      child: SlideTransition(
                        position: _slidetransition,
                        child: TextFormField(
                          enabled: _authMode == authmode.Signup,
                          decoration:
                              InputDecoration(labelText: "Confirm Passowrd"),
                          obscureText: true,
                          validator: _authMode == authmode.Signup
                              ? (value) {
                                  if (value != _passwordcontroller.text) {
                                    return "doesn't match";
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  _Isloading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          child: Text(_authMode == authmode.Login
                              ? 'LOGIN'
                              : 'SIGN UP'),
                          onPressed: () {
                            _saveform();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                          color: Theme.of(context).primaryColor,
                          textColor:
                              Theme.of(context).primaryTextTheme.button.color,
                        ),
                  FlatButton(
                    child: Text(
                        '${_authMode == authmode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                    onPressed: () {
                      _switchmode();
                    },
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
