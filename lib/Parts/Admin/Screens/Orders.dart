import 'package:flutter/material.dart';

class Orders extends StatelessWidget {

  static const String ORDERS = "/Orders";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(child: Center(child: Text("Orders"),),),
    );
  }
}
