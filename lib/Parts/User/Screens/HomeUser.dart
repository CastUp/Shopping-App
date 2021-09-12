import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  static const String HOME = "/Home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(child: Center(child: Text("Home User"),),),
    );
  }
}
