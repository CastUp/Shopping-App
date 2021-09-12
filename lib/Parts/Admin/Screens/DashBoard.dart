import 'package:flutter/material.dart';

class DashBoard extends StatelessWidget {

  static const String DASHBOARD = "/dashBoard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(child: Center(child: Text("DashBoard"),),),
    );
  }
}
