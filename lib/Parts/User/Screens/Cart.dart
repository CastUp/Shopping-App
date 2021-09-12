import 'package:flutter/material.dart';

class Cart extends StatelessWidget {

  static const String CART = "/Cart";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(child: Center(child: Text("Cart"),),),
    );
  }
}
