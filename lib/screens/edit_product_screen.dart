import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import '../provider/product_data.dart';

class EditProductScreen extends StatefulWidget {
  static const routeNamed = 'Edit_Product_Screen';
  const EditProductScreen({Key key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  final price_node = FocusNode();
  final description_node = FocusNode();
  final image_node = FocusNode();
  final _imagecontroller = TextEditingController();
  var _editedproducts = ProductModel(
      id: null, title: "", description: "", price: 0.0, imageUrl: "");

  var _initstate = true;
  var _isloading = false;

  var _inivalues = {
    "title": "",
    "description": "",
    "price": "",
    "imageurl": "",
  };

  @override
  void initState() {
    image_node.addListener(updateurl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initstate) {
      final productid = ModalRoute.of(context).settings.arguments as String;
      if (productid != null) {
        _editedproducts = Provider.of<Products>(context).findid(productid);
        _inivalues = {
          "title": _editedproducts.title,
          "description": _editedproducts.description,
          "price": _editedproducts.price.toString(),
          "imageurl": "",
        };
        _imagecontroller.text = _editedproducts.imageUrl;
      }
    }
    _initstate = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void updateurl() {
    if (!image_node.hasFocus) {
      if (_imagecontroller.text.isEmpty ||
          (!_imagecontroller.text.startsWith('https') &&
              (!_imagecontroller.text.startsWith('http')))) return;
    }
    setState(() {});
  }

  Future<void> _svaeform() async {
    setState(() {
      _isloading = true;
    });
    final _valid = _form.currentState.validate();
    if (!_valid) return;

    _form.currentState.save();

    if (_editedproducts.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateproduct(_editedproducts.id, _editedproducts);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .newproducts(_editedproducts);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Error occured"),
                  content: Text("Check your internet connection"),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "OK",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).errorColor),
                        ))
                  ],
                ));
      }
      // finally {
      //   setState(() {
      //     _isloading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isloading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    price_node.dispose();
    description_node.dispose();
    image_node.dispose();
    _imagecontroller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _svaeform)],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _inivalues["title"],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(price_node);
                      },
                      onSaved: (value) {
                        _editedproducts = ProductModel(
                            id: _editedproducts.id,
                            title: value,
                            description: _editedproducts.description,
                            price: _editedproducts.price,
                            imageUrl: _editedproducts.imageUrl,
                            isfavorite: _editedproducts.isfavorite);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter the title";
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _inivalues["price"],
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(price_node);
                      },
                      focusNode: description_node,
                      onSaved: (value) {
                        _editedproducts = ProductModel(
                            id: _editedproducts.id,
                            title: _editedproducts.title,
                            description: _editedproducts.description,
                            price: double.parse(value),
                            imageUrl: _editedproducts.imageUrl,
                            isfavorite: _editedproducts.isfavorite);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter the price";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please enter the valid number";
                        }
                        if (double.parse(value) == 0 | -1) {
                          return "Above zero";
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _inivalues["description"],
                      decoration: InputDecoration(labelText: 'Description'),
                      textInputAction: TextInputAction.newline,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        _editedproducts = ProductModel(
                            id: _editedproducts.id,
                            title: _editedproducts.title,
                            description: value,
                            price: _editedproducts.price,
                            imageUrl: _editedproducts.imageUrl,
                            isfavorite: _editedproducts.isfavorite);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter the Description";
                        }
                        if (value.length < 10) {
                          return "Atleast 10 Character above";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            height: 100.0,
                            width: 100.0,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.5, color: Colors.grey),
                            ),
                            child: _imagecontroller.text.isEmpty
                                ? Center(
                                    child: Text(
                                    "Enter the Image Url",
                                    textAlign: TextAlign.center,
                                  ))
                                : Container(
                                    child: Image.network(
                                      _imagecontroller.text,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                        SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "Image"),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imagecontroller,
                            focusNode: image_node,
                            onFieldSubmitted: (_) {
                              _svaeform();
                            },
                            onSaved: (value) {
                              _editedproducts = ProductModel(
                                  id: _editedproducts.id,
                                  title: _editedproducts.title,
                                  description: _editedproducts.description,
                                  price: _editedproducts.price,
                                  imageUrl: value,
                                  isfavorite: _editedproducts.isfavorite);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter the Imageurl";
                              }
                              if (!value.startsWith('https') &&
                                  !value.startsWith('http')) {
                                return 'Please enter the valid url';
                              }

                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
